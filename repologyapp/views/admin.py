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
from typing import Any, Callable, Dict, List

import flask

import psycopg2

from repologyapp.config import config
from repologyapp.db import get_db
from repologyapp.template_functions import url_for_self
from repologyapp.view_registry import ViewRegistrar


def unauthorized() -> Any:
    return flask.redirect(flask.url_for('admin'))


@ViewRegistrar('/admin', methods=['GET', 'POST'])
def admin() -> Any:
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

    return flask.render_template('admin.html')


def admin_reports_generic(report_getter: Callable[[], Dict[str, Any]]) -> Any:
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

    return flask.render_template('admin-reports.html', reports=report_getter())


@ViewRegistrar('/admin/reports/unprocessed/', methods=['GET', 'POST'])
def admin_reports_unprocessed() -> Any:
    return admin_reports_generic(lambda: get_db().get_unprocessed_reports(limit=config['REPORTS_PER_PAGE']))  # type: ignore


@ViewRegistrar('/admin/reports/recent/', methods=['GET', 'POST'])
def admin_reports_recent() -> Any:
    return admin_reports_generic(lambda: get_db().get_recently_updated_reports(limit=config['REPORTS_PER_PAGE']))  # type: ignore


@ViewRegistrar('/admin/updates')
def admin_updates() -> Any:
    if not flask.session.get('admin'):
        return unauthorized()

    return flask.render_template(
        'admin-updates.html',
        repos=get_db().get_repositories_update_diagnostics()
    )


@ViewRegistrar('/admin/redirects', methods=['GET', 'POST'])
def admin_redirects() -> Any:
    if not flask.session.get('admin'):
        return unauthorized()

    project = flask.request.args.get('project')

    redirects: List[Dict[str, Any]] = []

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
        'admin-redirects.html',
        project=project,
        redirects=redirects
    )


@ViewRegistrar('/admin/name_samples')
def admin_name_samples() -> Any:
    if not flask.session.get('admin'):
        return unauthorized()

    samples_by_repo: Dict[str, List[Dict[Any, Any]]] = defaultdict(list)

    for sample in get_db().get_name_samples(10):
        samples_by_repo[sample['repo']].append(sample)

    return flask.render_template(
        'admin-name-samples.html',
        samples_by_repo=samples_by_repo
    )


@ViewRegistrar('/admin/cpes', methods=['GET', 'POST'])
def admin_cpes() -> Any:
    if not flask.session.get('admin'):
        return unauthorized()

    if flask.request.method == 'POST':
        effname = flask.request.form.get('effname', '').strip()
        vendor = flask.request.form.get('cpe_vendor', '').strip()
        product = flask.request.form.get('cpe_product', '').strip()

        if flask.request.form.get('action') == 'add':
            if not effname:
                flask.flash('Project name not specified', 'danger')
            elif not vendor:
                flask.flash('CPE vendor not specified', 'danger')
            elif not product:
                flask.flash('CPE product not specified', 'danger')
            else:
                try:
                    get_db().add_manual_cpe(effname, vendor, product)
                    flask.flash(f'Manual CPE {vendor}:{product} added for {effname}', 'success')
                except psycopg2.errors.UniqueViolation:
                    flask.flash(f'Manual CPE {vendor}:{product} already exists for {effname}', 'danger')
        elif flask.request.form.get('action') == 'remove':
            get_db().remove_manual_cpe(effname, vendor, product)
            flask.flash(f'Manual CPE {vendor}:{product} removed for {effname}', 'success')
        elif flask.request.form.get('action') == 'autoadd':
            if not effname:
                flask.flash('Project name not specified', 'danger')
            else:
                added = get_db().auto_add_manual_cpes(effname)

                if added:
                    cpes = ', '.join(f'{vendor}:{product}' for vendor, product in added)
                    flask.flash(f'{len(added)} manual CPE(s) {cpes} autoadded for {effname}', 'success')
                else:
                    flask.flash(f'No manual CPE(s) for {effname} autoadded', 'warning')

        return flask.redirect(flask.url_for('admin_cpes'), 302)

    return flask.render_template(
        'admin-cpes.html',
        cpes=get_db().get_manual_cpes()
    )
