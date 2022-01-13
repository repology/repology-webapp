# Copyright (C) 2016 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

from repologyapp.cache import cache


_num_calls = 0


def produce(value):
    global _num_calls
    _num_calls += 1
    return value


def test_cache():
    assert _num_calls == 0

    # filled
    assert cache('label1', lambda: produce('foo')) == 'foo'
    assert _num_calls == 1

    # retrieved, not updated
    assert cache('label1', lambda: produce('foo')) == 'foo'
    assert _num_calls == 1

    # retrieved, not updated
    assert cache('label1', lambda: produce('bar')) == 'foo'
    assert _num_calls == 1

    # filled at another label
    assert cache('label2', lambda: produce('bar')) == 'bar'
    assert _num_calls == 2
