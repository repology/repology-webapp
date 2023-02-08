# Copyright (C) 2018-2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

from collections import defaultdict
from typing import Any, Callable

import flask

import psycopg2
import psycopg2.errors

from repologyapp.config import config
from repologyapp.db import get_db
from repologyapp.template_functions import url_for_self
from repologyapp.view_registry import Response, ViewRegistrar


def unauthorized() -> Response:
    return flask.redirect(flask.url_for('admin'))


@ViewRegistrar('/admin', methods=['GET', 'POST'])
def admin() -> Response:
    if flask.request.method == 'GET' and flask.session.get('admin'):
        return flask.redirect(flask.url_for('admin_reports_unprocessed'), 302)

    if flask.request.method == 'POST':
        if config['ADMIN_PASSWORD'] is None:
            flask.flash('Admin login disabled', 'danger')
        elif flask.request.form.get('password') is None:
            flask.session['admin'] = False
            flask.flash('Logged out successfully', 'success')
        elif flask.request.form.get('password') == config['ADMIN_PASSWORD']:
            flask.session['admin'] = True
            flask.flash('Logged in successfully', 'success')
        else:
            flask.flash('Incorrect admin password', 'danger')

        return flask.redirect(flask.url_for('admin'), 302)

    return flask.render_template('admin/_base.html')


def admin_reports_generic(report_getter: Callable[[], dict[str, Any]]) -> Response:
    if not flask.session.get('admin'):
        return unauthorized()

    if flask.request.method == 'POST':
        id_ = flask.request.form.get('id')
        reply = flask.request.form.get('reply', '')
        action = flask.request.form.get('action', None)

        if action == 'delete':
            get_db().delete_report(id_)
            flask.flash('Report removed succesfully', 'success')
            return flask.redirect(url_for_self())

        if action == 'accept':
            get_db().update_report(id_, reply, True)
        elif action == 'reject':
            get_db().update_report(id_, reply, False)
        else:
            get_db().update_report(id_, reply, None)

        flask.flash('Report updated succesfully', 'success')
        return flask.redirect(url_for_self())

    return flask.render_template('admin/reports.html', reports=report_getter())


@ViewRegistrar('/admin/reports/unprocessed/', methods=['GET', 'POST'])
def admin_reports_unprocessed() -> Response:
    return admin_reports_generic(lambda: get_db().get_unprocessed_reports(limit=config['REPORTS_PER_PAGE']))  # type: ignore


@ViewRegistrar('/admin/reports/recent/', methods=['GET', 'POST'])
def admin_reports_recent() -> Response:
    return admin_reports_generic(lambda: get_db().get_recently_updated_reports(limit=config['REPORTS_PER_PAGE']))  # type: ignore


@ViewRegistrar('/admin/updates')
def admin_updates() -> Response:
    if not flask.session.get('admin'):
        return unauthorized()

    return flask.render_template(
        'admin/updates.html',
        repos=get_db().get_repositories_update_diagnostics()
    )


@ViewRegistrar('/admin/redirects', methods=['GET', 'POST'])
def admin_redirects() -> Response:
    if not flask.session.get('admin'):
        return unauthorized()

    project = flask.request.args.get('project')

    redirects: list[dict[str, Any]] = []

    if project is not None:
        if flask.request.method == 'POST':
            action = flask.request.form.get('action')

            if action in ['add_in', 'add_out']:
                redirect = flask.request.form.get('redirect')

                if not redirect:
                    flask.flash('Redirect not specified', 'danger')
                elif redirect == project:
                    flask.flash('Refusing to add redirect from project to itself', 'danger')
                else:
                    try:
                        if action == 'add_in':
                            get_db().add_project_manual_redirect(redirect, project)
                        else:
                            get_db().add_project_manual_redirect(project, redirect)
                        flask.flash('Incoming redirect added', 'success')
                    except psycopg2.errors.UniqueViolation:
                        flask.flash('Redirect already exists', 'danger')
            elif flask.request.form.get('action') == 'remove':
                get_db().remove_project_manual_redirect(
                    flask.request.form.get('oldname'),
                    flask.request.form.get('newname')
                )
                flask.flash('Redirect removed', 'success')
            elif flask.request.form.get('action') == 'invert':
                try:
                    get_db().invert_project_manual_redirect(
                        flask.request.form.get('oldname'),
                        flask.request.form.get('newname')
                    )
                    flask.flash('Redirect inverted', 'success')
                except psycopg2.errors.UniqueViolation:
                    flask.flash('Inverted redirect already exists', 'danger')

            return flask.redirect(flask.url_for('admin_redirects', project=project), 302)

        redirects = get_db().get_project_redirects_admin(project, True) + get_db().get_project_redirects_admin(project, False)

    return flask.render_template(
        'admin/redirects.html',
        project=project,
        redirects=redirects
    )


@ViewRegistrar('/admin/name_samples')
def admin_name_samples() -> Response:
    if not flask.session.get('admin'):
        return unauthorized()

    samples_by_repo: dict[str, list[dict[Any, Any]]] = defaultdict(list)

    for sample in get_db().get_name_samples(10):
        samples_by_repo[sample['repo']].append(sample)

    return flask.render_template(
        'admin/name-samples.html',
        samples_by_repo=samples_by_repo
    )


class CpeVals:
    _values: dict[str, str]

    def __init__(self, form: dict[str, str] | None = None):
        self._values = {
            'cpe_vendor': '',
            'cpe_product': '',
            'cpe_edition': '*',
            'cpe_lang': '*',
            'cpe_sw_edition': '*',
            'cpe_target_sw': '*',
            'cpe_target_hw': '*',
            'cpe_other': '*',
        }

        if form is not None:
            for k in self._values.keys():
                if k in form:
                    self._values[k] = form[k]

    def check_all(self) -> bool:
        for k, v in self._values.items():
            if not v:
                flask.flash(f'{k} not specified', 'danger')
                return False

        return True

    @property
    def cpe(self) -> str:
        return ':'.join(['cpe', '2.3', 'a'] + [v for k, v in self._values.items() if k.startswith('cpe_')])


def handle_cpe_request() -> Response | None:
    """Process POST request related to CPEs.

    Does necessary checks and modifications to the database, and
    returns either the (redirect) response to be passed through,
    or None which would mean that the calling endpoint should
    be re-rendered with form fields filled with values from request,
    allowing the user to do necessary changes.
    """
    effname = flask.request.form.get('effname', '').strip()

    if not effname:
        flask.flash('Project name not specified', 'danger')
        return None

    cpe_keys = ['cpe_vendor', 'cpe_product', 'cpe_edition', 'cpe_lang', 'cpe_sw_edition', 'cpe_target_sw', 'cpe_target_hw', 'cpe_other']
    cpe_args = {key: flask.request.form.get(key, '').strip() for key in cpe_keys}

    def format_cpe(vals: dict[str, str]) -> str:
        return ':'.join(['cpe', '2.3', 'a'] + [vals[k] for k in cpe_keys])

    def check_required_cpe_fields() -> bool:
        if not cpe_args['cpe_vendor']:
            flask.flash('CPE vendor not specified', 'danger')
        elif not cpe_args['cpe_product']:
            flask.flash('CPE product not specified', 'danger')
        else:
            return True
        return False

    added_cpes = []
    removed_cpes = []

    if flask.request.form.get('action') == 'add':
        if not check_required_cpe_fields():
            return None

        if not (added_cpes := get_db().add_manual_cpe(effname, **cpe_args)):
            flask.flash(f'Cound not add {format_cpe(cpe_args)} for {effname}, already exists', 'warning')

    elif flask.request.form.get('action') == 'autoadd':
        if not (added_cpes := get_db().auto_add_manual_cpes(effname)):
            flask.flash(f'Could not autoadd any CPEs for {effname}', 'warning')

    elif flask.request.form.get('action') == 'remove':
        if not check_required_cpe_fields():
            return None

        if not (removed_cpes := get_db().remove_manual_cpe(effname, **cpe_args)):
            flask.flash(f'Could not remove CPE {format_cpe(cpe_args)} for {effname}', 'danger')

    elif flask.request.form.get('action') == 'redirect':
        if not check_required_cpe_fields():
            return None

        redirs = get_db().get_project_redirects(effname)

        if len(redirs) == 0:
            flask.flash(f'No redirects found for {effname}', 'danger')
        elif len(redirs) > 1:
            flask.flash(f'Redirect for {effname} leads to multiple projects {", ".join(redirs)}, cannot automatically resolve', 'danger')
        elif not (removed_cpes := get_db().remove_manual_cpe(effname, **cpe_args)):
            # if we cannot remove old redirect, something is wrong, don't continue
            flask.flash(f'Cannot remove CPE {format_cpe(cpe_args)} for {effname}', 'danger')
        elif not (added_cpes := get_db().add_manual_cpe(redirs[0], **cpe_args)):
            # we may fail to add target CPE if it already exists, this is normal
            flask.flash(f'Cound not add {format_cpe(cpe_args)} for {redirs[0]}, already exists', 'warning')

    for cpe in added_cpes:
        flask.flash(f'CPE {format_cpe(cpe)} added for {cpe["effname"]}', 'success')
    for cpe in removed_cpes:
        flask.flash(f'CPE {format_cpe(cpe)} removed for {cpe["effname"]}', 'success')

    return flask.redirect(url_for_self(), 302)


@ViewRegistrar('/admin/cpes', methods=['GET', 'POST'])
def admin_cpes() -> Response:
    if not flask.session.get('admin'):
        return unauthorized()

    if flask.request.method == 'POST':
        if (response := handle_cpe_request()) is not None:
            return response

    return flask.render_template(
        'admin/cpes.html',
        cpes=get_db().get_manual_cpes()
    )


@ViewRegistrar('/admin/cve_misses', methods=['GET', 'POST'])
def admin_cve_misses() -> Response:
    if not flask.session.get('admin'):
        return unauthorized()

    if flask.request.method == 'POST':
        if (response := handle_cpe_request()) is not None:
            return response

    return flask.render_template(
        'admin/cve-misses.html',
        items=get_db().get_recent_cve_misses()
    )


@ViewRegistrar('/admin/omni_cves')
def admin_omni_cves() -> Response:
    if not flask.session.get('admin'):
        return unauthorized()

    return flask.render_template(
        'admin/omni-cves.html',
        items=get_db().get_omni_cves()
    )
