all: test

filename=markment-`python -c 'import markment.version;print markment.version.version'`.tar.gz

export PYTHONPATH:=  ${PWD}

test: deps clean unit functional doctests integration

doctests:
	@steadymark spec/*.md

deps:
	@pip install curdling
	@curd install -r requirements-dev.txt

unit: clean
	@echo "Running unit tests"
	@nosetests --cover-branches --with-coverage  --cover-erase --cover-package=markment --stop -v -s tests/unit

functional: clean prepare
	@echo "Running functional tests"
	@nosetests --stop -v -s tests/functional

integration: clean
	@python markment/bin.py -o ./_public/ .
	@python markment/bin.py --porcelain -o ./_public/ example
	@python markment/bin.py --porcelain -t slate -o ./_public/ --sitemap-for=http://falcao.it/markment example

docs: clean doctests
	@git co master && \
		(git br -D gh-pages || printf "") && \
		git checkout --orphan gh-pages && \
		python markment/bin.py -o . -t rtd --sitemap-for="http://falcao.it/markment" spec && \
		git add . && \
		git commit -am 'documentation' && \
		git push --force origin gh-pages && \
		git checkout master

clean:
	@printf "Cleaning up files that are already in .gitignore... "
	@for pattern in `cat .gitignore`; do rm -rf $$pattern; find . -name "$$pattern" -exec rm -rf {} \;; done
	@echo "OK!"

release: test docs
	@./.release
	@python setup.py sdist register upload

prepare:
	@mkdir -p output

theme:
	@python markment/bin.py -t rtd --server spec

run: clean
	@reset && python markment/server.py
