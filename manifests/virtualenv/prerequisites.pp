# Need the virtualenv package and Python setup tools which is included in python-devel
class python::virtualenv::prerequisites {

    # necessary for many pip package installs
    package { 'gcc':
        ensure => installed,
    }

    package { 'python-devel':
        ensure => installed,
    }

    package { 'python-virtualenv':
        ensure => installed,
    }

}
