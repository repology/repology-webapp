FLAKE8?=	flake8
MYPY?=		mypy

STATICDIR=	repologyapp/static

all: gzip-static

gzip-static:
	gzip -9 -f -k -v ${STATICDIR}/*.css ${STATICDIR}/*.js ${STATICDIR}/*.ico ${STATICDIR}/*.svg

clean:
	rm -f ${STATICDIR}/*.gz

lint:: test flake8 mypy

test::
	python3 -m unittest discover

full-test::
	env REPOLOGY_CONFIG=./repology-test.conf.default ./repology-update.py -ippd
	env REPOLOGY_CONFIG=./repology-test.conf.default python3 -m unittest discover

flake8:
	${FLAKE8} --count *.py repologyapp

mypy:
	${MYPY} *.py repologyapp
	${MYPY} repologyapp/views
