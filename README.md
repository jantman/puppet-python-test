puppet-python-test
==================

[![Project Status: Abandoned - Initial development has started, but there has not yet been a stable, usable release; the project has been abandoned and the author(s) do not intend on continuing development.](http://www.repostatus.org/badges/0.1.0/abandoned.svg)](http://www.repostatus.org/#abandoned)

__This should NOT be used__. It's really quite poor in its current state. I'm working on getting a much better version open-sourced by my employer.

This is a 'python' puppet module.

It was derived from the Mozilla Release Engineering "PuppetAgain" python module, 
https://github.com/mozilla/build-puppet-manifests/tree/master/modules/python
but heavily modified by a former colleague of mine. In fact, I'm not even sure
if I should call this "heavily modified" or "inspired by".

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

LICENSE
-------
Unknown until I heard back from Mozilla Release Engineering. For the time
being, please treat this as copyrighted code under a restrictive license,
until I get confirmation. I assume, since it's from Mozilla, it will probably
be under MPL. While both my employer and I have (differing) opinions on our
default license, our derivative work will be under whatever the license the
original work used.
