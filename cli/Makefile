env: env/bin/activate

env/bin/activate: requirements.txt
	test -d env || virtualenv env
	. env/bin/activate; pip install -Ur requirements.txt
	touch env/bin/activate

clean:
	rm -rf env
	find -iname "*.pyc" -delete

install: env setup.py che_installer_rest/cli.py
	env/bin/python setup.py develop
