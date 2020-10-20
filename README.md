# Repology

[![Build Status](https://travis-ci.org/repology/repology-webapp.svg?branch=master)](https://travis-ci.org/repology/repology-webapp)
[![codecov](https://codecov.io/gh/repology/repology-webapp/branch/master/graph/badge.svg)](https://codecov.io/gh/repology/repology-webapp)

Repology is a service which monitors *a lot* of package repositories
and other sources and aggregates data on software package versions,
reporting new releases and packaging problems.

This repository contains Repology web application code. [See](https://repology.org/) it online.
See also the [updater](https://github.com/repology/repology-updater) code, a backend service
which updates the repository information.

## Dependencies

- [Python](https://www.python.org/) 3.9+
- Python module [flask](http://flask.pocoo.org/)
- Python module [libversion](https://pypi.python.org/pypi/libversion) (also requires [libversion](https://github.com/repology/libversion) C library)
- Python module [pillow](https://pypi.python.org/pypi/Pillow)
- Python module [psycopg2](http://initd.org/psycopg/)
- [PostgreSQL](https://www.postgresql.org/) 13.0+
- PostgreSQL extension [libversion](https://github.com/repology/postgresql-libversion)

### For development

For HTML validation in tests:
- Python module [pytidylib](https://pypi.python.org/pypi/pytidylib) and [tidy-html5](http://www.html-tidy.org/) library

For python code linting:
- Python module [flake8](https://pypi.python.org/pypi/flake8)
- Python module [flake8-builtins](https://pypi.python.org/pypi/flake8-builtins)
- Python module [flake8-import-order](https://pypi.python.org/pypi/flake8-import-order)
- Python module [flake8-quotes](https://pypi.python.org/pypi/flake8-quotes)
- Python module [mypy](http://mypy-lang.org/)

## Running

### Preparing the database

To run the webapp, you first need a database created and filled
by repology-updater as [explained](https://github.com/repology/repology-updater#running)
in its documentation.

### Running the webapp

Repology is a flask application, so as long as you've set up
database and configuration, you may just run the application
locally:

```
./repology-app.py
```

and point your browser to http://127.0.0.1:5000/ to view the
site. This should be enough for personal use, experiments and
testing.

Alternatively, you may deploy the application in numerous ways,
including mod_wsgi, uwsgi, fastcgi and plain CGI application. See
[flask documentation on deployment](http://flask.pocoo.org/docs/deploying/)
for more info.

For instance, you can deploy with `uwsgi` with the following command
line arguments:

```
uwsgi --mount /=repology-app:app --pythonpath=<path-to-repology-checkout>
```

## Author

* [Dmitry Marakasov](https://github.com/AMDmi3) <amdmi3@amdmi3.ru>

## License

GPLv3 or later, see [COPYING](COPYING).
