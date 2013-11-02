puppet-python-test
==================

This is a 'python' puppet module.

It was derived from the Mozilla Release Engineering "PuppetAgain" python module:
http://mxr.mozilla.org/build/source/puppet-manifests/modules/python/
but heavily modified by a former colleague of mine.

It is __not__ considered ready to be released to the community. and currently has a number of major issues. 

I'm posting it as part of the discussion I started on [Puppet-Users](https://groups.google.com/forum/#!topic/puppet-users/P2ekwQm6iS4)
and [mozilla.tools.puppetagain](https://groups.google.com/forum/#!topic/mozilla.tools.puppetagain/5TOkiYbYTrQ)

Specifically, all it is capable of doing is:
* ensure that gcc, python-devel and python-virtualenv packages are installed
* provide a define to create a venv at a specified location, using a specified base python binary, and optionally pip install a specified list of packages
* provide a define to pip install a specific package within the venv

There are a few outright bugs in it (like no shell escaping in package names, so trying to install "django>=1.0" installs "django" and redirects the output of pip to a "=1.0" file in the venv base),
and a number of serious feature omissions (no requirments file handling, can't install the same package in multiple venvs on a node)

At the time it was written, this seemed OK for us (a Python shop) as we either used the default system python, or an application-specific venv built by Hudson.
