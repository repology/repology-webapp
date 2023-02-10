# Copyright (C) 2017 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

import pytest

from repologyapp.config import config
from repologyapp.fontmeasurer import FontMeasurer


@pytest.fixture
def font_measurer():
    if 'BADGE_FONT' not in config:
        pytest.skip('font measurer test requires BADGE_FONT configuration directive defined')
    return FontMeasurer(config['BADGE_FONT'], 11)


def test_fontmeasurer(font_measurer):
    first_result = font_measurer.get_text_width('The quick brown fox jumps over the lazy dog')
    cached_result = font_measurer.get_text_width('The quick brown fox jumps over the lazy dog')

    assert first_result == cached_result

    # I expect some fluctuations due to different freetype version
    # or hinting settions.
    #
    # Currently though, there's 10 pixel difference between FreeBSD
    # and Ubuntu which is too big to be expected, should investigate.
    #
    # In practice though, our strings are usually shorter and we have
    # 6 pixel padding in badges, so it should not be fatal.

    expected_widths = [
        247,  # 2023: Ubuntu
        257,  # 2023: FreeBSD
        254,  # 2017: FreeBSD
        258,  # 2017: Ubuntu
    ]

    assert min(expected_widths) <= first_result
    assert first_result <= max(expected_widths)
