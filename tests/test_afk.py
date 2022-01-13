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

from datetime import date

from repologyapp.afk import AFKChecker


def test_empty():
    afk = AFKChecker()

    assert afk.get_afk_end() is None
    assert afk.get_afk_end(date(2017, 1, 1)) is None


def test_day():
    afk = AFKChecker(['2017-01-02'])

    assert afk.get_afk_end(date(2017, 1, 1)) is None
    assert afk.get_afk_end(date(2017, 1, 2)) == date(2017, 1, 2)
    assert afk.get_afk_end(date(2017, 1, 3)) is None


def test_range():
    afk = AFKChecker(['2017-01-02 2017-01-04'])

    assert afk.get_afk_end(date(2017, 1, 1)) is None
    assert afk.get_afk_end(date(2017, 1, 2)) == date(2017, 1, 4)
    assert afk.get_afk_end(date(2017, 1, 3)) == date(2017, 1, 4)
    assert afk.get_afk_end(date(2017, 1, 4)) == date(2017, 1, 4)
    assert afk.get_afk_end(date(2017, 1, 5)) is None


def test_multi():
    afk = AFKChecker(['2017-01-02', '2017-01-04 2017-01-05'])

    assert afk.get_afk_end(date(2017, 1, 1)) is None
    assert afk.get_afk_end(date(2017, 1, 2)) == date(2017, 1, 2)
    assert afk.get_afk_end(date(2017, 1, 3)) is None
    assert afk.get_afk_end(date(2017, 1, 4)) == date(2017, 1, 5)
    assert afk.get_afk_end(date(2017, 1, 5)) == date(2017, 1, 5)
    assert afk.get_afk_end(date(2017, 1, 6)) is None
