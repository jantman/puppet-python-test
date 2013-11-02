# = Define: python::virtualenv
#
# Defines and sets up a Python virtualenv
#
# == Actions:
# - require python::virtualenv::prerequisites
# - if ensure is "absent", recursively remove $title (the name of the resource)
# - otherwise (ensure is "present", default):
#   - create the directory specified by the resource title
#   - run '$python -BE /usr/bin/virtualenv --python=$python $virtualenv'
#   - copy bin/pip-package-check.py from this module into the venv
#   - use python::virtualenv::package::install resources to install the packages specified by $packages, also passing in $strict_versioning and $pip_options
#
# == Parameters:
#
# $title:: Absolute path to the venv directory (this is the resource title). This is also the directory that the "virtualenv" command and all pip commands are run from.
#
# $python:: Path to python binary to use (default: "/usr/bin/python")
#
# $ensure:: Action to take - must be present or absent. Absent recursively removes the venv directory. ("present" or "absent", default "present")
#
# $packages:: List of packages to pip install in the venv. (default: [])
#
# $user:: User to own the venv (default: "root")
#
# $group:: Group to own the venv (default: "root")
#
# $strict_versioning:: Boolean, optional value to pass to python::virtualenv::package::install resources, specifying whether we allow packages without explicit versions (i.e. without "==" in the name) to be installed.
#
# $pip_options:: Optional string of other options to pass to python::virtualenv::package::install resources, to be used in pip commands.
#
# == Sample Usage:
#
#   python::virtualenv {"/path/to/venv":
#      ensure   => present,
#      packages => ['foo', 'bar', 'baz'],
#      user     => 'myuser',
#      group    => 'mygroup',
#   }
#
# == Notes:
#
#
define python::virtualenv($python="/usr/bin/python", $ensure="present", $packages=[] , $user="root", $group="root", $strict_versioning=false, $pip_options='')
{

    require python::virtualenv::prerequisites 

    # Location of virtual environment is the passed in title
    $virtualenv = $title

    case $ensure {

        present: {
            # Create the virtual environment directory
            file {$virtualenv:
                owner   => $user,
                group   => $group,
                ensure  => directory,
                recurse => true
            }

            # Setup the virtual environment
            exec {"virtualenv ${virtualenv}":
                name => "${python} -BE /usr/bin/virtualenv --python=${python} ${virtualenv}",
                user => $user,
                logoutput => on_failure,
                require   => [
                    File[$virtualenv],
                    Class['python::virtualenv::prerequisites']
                ],
                cwd     => $virtualenv, 
                creates => "${virtualenv}/bin/pip";
            }

            # Copy pip package check script to virtual environment
            file {"${virtualenv}/bin/pip-package-check.py":
                owner   => $user,
                group   => $group,
                ensure  => file,
                mode    => 755,
                source  => "puppet:///modules/python/pip-package-check.py",
                require => Exec["virtualenv ${virtualenv}"],
            }

            if $packages != null {
                python::virtualenv::package::install { $packages:
                    ve_user           => $user,
                    ve_group          => $group,
                    virtualenv        => $virtualenv,
                    strict_versioning => $strict_versioning,
                    pip_options       => $pip_options,
                    require           => File["${virtualenv}/bin/pip-package-check.py"],
                }
            }
        }

        absent: {
            # destroy the virtual env directory
            file { $virtualenv:
                ensure => absent,
                backup => false,
                force  => true;
            }
        }
    }
}
