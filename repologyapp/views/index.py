# Copyright (C) 2016-2017 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

from dataclasses import dataclass
from typing import Dict, List

import flask

from repologyapp.cache import cache
from repologyapp.db import get_db
from repologyapp.globals import repometadata
from repologyapp.math import safe_percent
from repologyapp.metapackages import packages_to_summary_items
from repologyapp.package import PackageDataSummarizable
from repologyapp.view_registry import Response, ViewRegistrar


class Top:
    @dataclass
    class Item:
        group: str
        name: str
        value: float

    @dataclass
    class _Group:
        name: str
        value: float

    _top: Dict[str, 'Top._Group']
    _reverse: bool

    def __init__(self, reverse: bool = False) -> None:
        self._top = {}
        self._reverse = reverse

    def add(self, group: str, name: str, value: float) -> None:
        if group not in self._top or value > self._top[group].value:
            self._top[group] = Top._Group(name, value)

    def get(self, count: int) -> List['Top.Item']:
        return [
            Top.Item(groupname, groupdata.name, groupdata.value)
            for groupname, groupdata in sorted(
                self._top.items(),
                key=lambda group: group[1].value,
                reverse=not self._reverse
            )[:count]
        ]


@ViewRegistrar('/')
def index() -> Response:
    top_by_total = Top()
    top_by_nonunique = Top()
    top_by_newest = Top()
    top_by_pnewest = Top()
    top_by_maintainers = Top()
    top_by_problematic = Top()  # not used right now
    top_by_ppm = Top(reverse=True)

    for repo in get_db().get_active_repositories():
        metadata = repometadata[repo['name']]
        if metadata['type'] != 'repository':
            continue
        top_by_total.add(metadata['statsgroup'], repo['name'], repo['num_metapackages'])
        top_by_nonunique.add(metadata['statsgroup'], repo['name'], repo['num_metapackages'] - repo['num_metapackages_unique'])
        top_by_newest.add(metadata['statsgroup'], repo['name'], repo['num_metapackages_newest'])
        top_by_maintainers.add(metadata['statsgroup'], repo['name'], repo['num_maintainers'])
        top_by_problematic.add(metadata['statsgroup'], repo['name'], safe_percent(repo['num_metapackages_problematic'], repo['num_metapackages']))

        if repo['num_metapackages'] > 1000:
            top_by_pnewest.add(metadata['statsgroup'], repo['name'], safe_percent(repo['num_metapackages_newest'], repo['num_metapackages_comparable']))
            if repo['num_maintainers'] > 0:
                top_by_ppm.add(metadata['statsgroup'], repo['name'], repo['num_metapackages'] / repo['num_maintainers'])

    important_packages = [
        'apache24',
        'awesome',
        'bash',
        'binutils',
        'bison',
        'blender',
        'boost',
        'bzip2',
        'chromium',
        'claws-mail',
        'cmake',
        'cppcheck',
        'cups',
        'curl',
        'darktable',
        'dia',
        'djvulibre',
        'dosbox',
        'dovecot',
        'doxygen',
        'dvd+rw-tools',
        'emacs',
        'exim',
        'ffmpeg',
        'firefox',
        'flex',
        'fluxbox',
        'freecad',
        'freetype',
        'gcc',
        'gdb',
        'geeqie',
        'gimp',
        'git',
        'gnupg',
        'go',
        'graphviz',
        'grub',
        'icewm',
        'imagemagick',
        'inkscape',
        'irssi',
        'kodi',
        'lame',
        'lftp',
        'libreoffice',
        'libressl',
        'lighttpd',
        'links',
        'llvm',
        'mariadb',
        'maxima',
        'mc',
        'memcached',
        'mercurial',
        'mesa',
        'mplayer',
        'mutt',
        'mysql',
        'nginx',
        'nmap',
        'octave',
        'openbox',
        'openssh',
        'openssl',
        'openttf',
        'openvpn',
        'p7zip',
        'perl',
        'pidgin',
        'postfix',
        'postgresql',
        'privoxy',
        'procmail',
        'python',
        'qemu',
        'rdesktop',
        'redis',
        'rrdtool',
        'rsync',
        'rtorrent',
        'rxvt-unicode',
        'samba',
        'sane-backends',
        'scons',
        'screen',
        'scribus',
        'scummvm',
        'sdl2',
        'smartmontools',
        'sqlite',
        'squid',
        'subversion',
        'sudo',
        'sumversion',
        'thunderbird',
        'tigervnc',
        'tmux',
        'tor',
        'valgrind',
        'vim',
        'virtualbox',
        'vlc',
        'vsftpd',
        'wayland',
        'wesnoth',
        'wget',
        'wine',
        'wireshark',
        'xorg-server',
        'youtube-dl',
        'zsh',
    ]

    # put into a single cache entry to avoid desync
    metapackages, metapackagedata = cache(
        'index-packages',
        lambda: (
            get_db().get_metapackages(important_packages),
            packages_to_summary_items(
                PackageDataSummarizable(**item)
                for item in get_db().get_metapackages_packages(important_packages, summarizable=True)
            )
        )
    )

    top_size = 10

    return flask.render_template(
        'index.html',
        top_by_total=top_by_total.get(top_size),
        top_by_nonunique=top_by_nonunique.get(top_size),
        top_by_newest=top_by_newest.get(top_size),
        top_by_pnewest=top_by_pnewest.get(top_size),
        top_by_maintainers=top_by_maintainers.get(top_size),
        top_by_ppm=top_by_ppm.get(top_size),
        metapackages=metapackages,
        metapackagedata=metapackagedata
    )
