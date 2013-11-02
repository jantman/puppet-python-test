# = Define: python::virtualenv::package::install
#
# Installs package(s) in a virtualenv via pip.
#
# == Actions:
# - if $strict_versioning == true, ensure that package name (resource title) includes "=="
# - execute pip install in the specified virtualenv, to install the specified package
#
# == Parameters:
#
# $title:: Name of the package to pip install, optionally including version specifier.
#
# $ve_user:: User who owns the venv, to execute the pip command as.
#
# $ve_group:: Group who owns the venv, to execute the pip command as.
#
# $virtualenv:: Absolute path to the virtualenv to pip install the package in.
#
# $pip_options:: Optional string of other options to pass to pip between "install" and the package name/spec.
#
# $strict_versioning:: Boolean, if true will require that $title (package name) include "==", else will fail.
#
# == Sample Usage:
#
#   python::virtualenv::package::install {"/path/to/venv":
#      ensure   => present,
#      packages => ['foo', 'bar', 'baz'],
#      user     => 'myuser',
#      group    => 'mygroup',
#   }
#
# == Notes:
#
#
define python::virtualenv::package::install($ve_user,$ve_group,$virtualenv,$pip_options='',$strict_versioning=false) {

    $package = $name

    # Causes Puppet agent run to fail if strict versioning is enabled and not all pip packages contain versions.
    if($strict_versioning == true) {
        if($package !~ /==/) {
            fail("You have requested strict versioning but package ${package} does not specify a version. Please set strict versioning to false or pass in a ${package} version. Example: ${package}==1.0.0")
        }
    }

    exec {"pip ${package}":
        name      => "${virtualenv}/bin/pip install ${pip_options} ${package}",
        user      => $ve_user,
        logoutput => on_failure,
        group     => $ve_group,
        cwd       => $virtualenv,
        onlyif    => "${virtualenv}/bin/python ${virtualenv}/bin/pip-package-check.py ${package}",
    }
}
