import sys
import pkg_resources
import traceback

#
# This pip helper script is intended to return one if a package is
# installed, zero if not. This is the desired behavior as we are using
# it with Puppet's 'onlyif' check in an exec type that installs a package
# (see ../manifests/virtualenv/package.pp) only if it is not already installed.
#
# From Puppet's exec reference for onlyif:
#  "If this parameter is set, then this exec will only run if the command returns 0."
#

pkg_name = sys.argv[1]

try:

    req = pkg_resources.Requirement.parse(pkg_name)
    dist = pkg_resources.working_set.find(req)

    if dist: # package was found
        print pkg_name + " is installed."
        sys.exit(1) 
    else: # package not found
        print pkg_name + " is not installed."
        sys.exit()

# If any of these exceptions are thrown the Puppet run will fail so we should print out as much
# info as possible.

except pkg_resources.VersionConflict:
    print pkg_name + " caused a version conflict."
    traceback.print_exc()

except pkg_resources.DistributionNotFound:
    print "A distribution needed to fulfill a requirement for " + pkg_name + " could not be found."
    traceback.print_exc()

except Exception: # Unknown exception encountered
    print "An unknown exception occured while trying to install " + pkg_name
    traceback.print_exc()
