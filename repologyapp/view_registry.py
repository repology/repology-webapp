# Copyright (C) 2017-2018 Dmitry Marakasov <amdmi3@amdmi3.ru>
#
# This file is part of repology
#
# repology is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# repology is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with repology.  If not, see <http://www.gnu.org/licenses/>.

import importlib
import inspect
import os
import types
from typing import Any, Callable, Iterator, TypeAlias, Union

import flask

import werkzeug


# Corresponds to flask typeshed, but simpler and stricter
_Status: TypeAlias = int
_Headers: TypeAlias = dict[str, str]
_Body: TypeAlias = str | werkzeug.Response  # the latter is returned by e.g. flask.redirect
Response: TypeAlias = _Body | tuple[_Body, _Status, _Headers] | tuple[_Body, _Status] | tuple[_Body, _Headers]
_ViewFunc: TypeAlias = Callable[..., Response]


def _enumerate_modules(pkgname: str, pkgfile: str) -> Iterator[types.ModuleType]:
    pkgdir = os.path.dirname(pkgfile)

    for modfile in os.listdir(pkgdir):
        modname = inspect.getmodulename(os.path.join(pkgdir, modfile))
        if modname and modname != '__init__':
            yield importlib.import_module(pkgname + '.' + modname)


class ViewRegistrant():
    _f: _ViewFunc
    _next: Union['ViewRegistrant', None]
    _route: str
    _options: dict[str, Any]
    _group: str | None

    def __init__(self, f: 'ViewRegistrant' | _ViewFunc, route: str, options: dict[str, Any]) -> None:
        if isinstance(f, ViewRegistrant):
            # allow nesting
            self._f = f._f
            self._next = f
        else:
            self._f = f
            self._next = None

        self._route = route
        self._options = options
        self._group = options.get('group')
        if self._group:
            del options['group']

    def __call__(self, *args: Any, **kwargs: Any) -> Any:
        return self._f(*args, **kwargs)

    def register_in_flask(self, app: flask.Flask) -> None:
        app.add_url_rule(self._route, self._f.__name__, self._f, **self._options)
        if self._next is not None:
            self._next.register_in_flask(app)

    def get_name_to_group(self) -> tuple[str, str | None]:
        return (self._f.__name__, self._group)


class ViewRegistrar():
    _route: str
    _options: dict[str, Any]

    def __init__(self, route: str, **options: Any) -> None:
        self._route = route
        self._options = options

    def __call__(self, f: _ViewFunc) -> ViewRegistrant:
        return ViewRegistrant(f, self._route, self._options)


class ViewRegistry():
    _registrants: list[ViewRegistrant]
    _groups_by_endpoint: dict[str, str]

    def __init__(self, pkgname: str, pkgfile: str) -> None:
        self._registrants = []

        for module in _enumerate_modules(pkgname, pkgfile):
            for name, member in inspect.getmembers(module):
                if isinstance(member, ViewRegistrant):
                    self._registrants.append(member)

        self._group_by_endpoint = {}
        for (name, group) in [registrant.get_name_to_group() for registrant in self._registrants]:
            if group:
                self._group_by_endpoint[name] = group

    def register_in_flask(self, app: flask.Flask) -> None:
        for registrant in self._registrants:
            registrant.register_in_flask(app)

    def get_current_endpoint_group(self) -> str | None:
        assert flask.request.endpoint
        return self._group_by_endpoint.get(flask.request.endpoint)
