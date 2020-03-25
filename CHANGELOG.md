# CHANGELOG for DVWA

This file is used to list changes made in each version of dvwa.

## 0.4.0:

* Update default DVWA version to master (no recent release)
* Remove PostgreSQL support, this DBMS is not fully supported by DVWA
* Remove postgresql cookbook dependency (no longer supported)
* Remove database cookbook dependency (deprecated)
* Remove mysql cookbook dependency (replaced by mariadb)
* Remove mysql2_chef_gem cookbook dependency
* Add mariadb cookbook dependency
* Remove support for Ubuntu 14.04 (cannot authenticate mariadb/mysql packages)
* Add support for Ubuntu 16.04 & 18.04
* Add support for Debian 9 & 10
* Update for latest php & apache2 cookbooks
* Fix CI

## 0.3.0:

* Chef 13 compatibility
* Support Ubuntu 14.04

## 0.2.1:

* Install mysql2 gem package with `mysql2_chef_gem` cookbook

## 0.2.0:

* Chef 12 compatibility
* Use Rake instead of Strainer
* Test hardness (rubocop, chefspec)


## 0.1.3:

* Changed license for Apache 2.0

## 0.1.2:

* Integration testing with serverspec and test-kitchen

## 0.1.1:

* Remove and ignore tracked files *.lock
* Readme improvements
* Running tests with strainer
* Added travis continuous integration
* Tests refactoring

## 0.1.0:

* Initial release of dvwa
