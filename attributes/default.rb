# This source file is part of DVWA's chef cookbook.
#
# DVWA's chef cookbook is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# DVWA's chef cookbook is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with DVWA's chef cookbook. If not, see <http://www.gnu.org/licenses/gpl-3.0.html>.
#
# Cookbook Name:: dvwa
# Attribut:: default
#

# Database configuration
default["dvwa"]["db"]["use_psql"] = false
default["dvwa"]["db"]["port"]     = 5432 # Only needed for psql dbms
default["dvwa"]["db"]["name"]     = "dvwa"
default["dvwa"]["db"]["username"] = "dvwa"
default["dvwa"]["db"]["password"] = "dvwa"

# Recaptcha settings
default["dvwa"]["recaptcha"]["public_key"]  = "6LfzKeUSAAAAABbGMjVS77HmkY7emIB9v5VGeEvb"
default["dvwa"]["recaptcha"]["private_key"] = "6LfzKeUSAAAAAEPD91_3uUGaemNs9ZNehkccBOoF"

# Apache2 configuration
default["dvwa"]["apache2"]["server_name"] = "dvwa"
default["dvwa"]["apache2"]["server_aliases"] = [ "dvwa" ]

# DVWA application
default["dvwa"]["version"] = "v1.0.8"
default["dvwa"]["path"]    = "/opt/dvwa"
default["dvwa"]["security_level"] = "high"
