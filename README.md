DVWA Cookbook
=============
Deploy a Damn Vulnerable Web Application environment.
[![Cookbook Version](https://img.shields.io/cookbook/v/dvwa.svg)](https://community.opscode.com/cookbooks/dvwa) [![Build Status](https://secure.travis-ci.org/wargames-cookbooks/dvwa.png)](http://travis-ci.org/wargames-cookbooks/dvwa)

Requirements
------------

#### Platform
- `Ubuntu 14.04`

#### Cookbooks
- `apache2` - https://supermarket.chef.io/cookbooks/apache2
- `php` - https://supermarket.chef.io/cookbooks/php
- `database` - https://supermarket.chef.io/cookbooks/database
- `mysql` - https://supermarket.chef.io/cookbooks/mysql
- `mysql2_chef_gem` - https://supermarket.chef.io/cookbooks/mysql2_chef_gem
- `postgresql` - https://supermarket.chef.io/cookbooks/postgresql

Attributes
----------

#### dvwa::default
| Key                               | Type   |  Description                                                                 |
| --------------------------------- | ------- | --------------------------------------------------------------------------- |
| `[dvwa][db][use_pgsql]`           | Boolean | Use Postgresql instead MySQL (default: `false`)                             |
| `[dvwa][db][server]`              | String  | Database server host (default: `localhost`)                                 |
| `[dvwa][db][port]`                | Integer | Database port, only needed for postgresql dbms (default: `5432`)            |
| `[dvwa][db][name]`                | String  | Database name (default: `dvwa`)                                             |
| `[dvwa][db][username]`            | String  | Database user name (default: `dvwa`)                                        |
| `[dvwa][db][password]`            | String  | Database user password (default: `dvwa`)                                    |
| `[dvwa][recaptcha][public_key]`   | String  | Recaptcha public key (default: `6LfzKeUSAAAAABbGMjVS77HmkY7emIB9v5VGeEvb`)  |
| `[dvwa][recaptcha][private_key]`  | String  | Recaptcha private key (default: `6LfzKeUSAAAAAEPD91_3uUGaemNs9ZNehkccBOoF`) |
| `[dvwa][apache2][server_name]`    | String  | Apache2 server name (default: `dvwa`)                                       |
| `[dvwa][apache2][server_aliases]` | Array   | Array of apache2 virtualhost aliases (default: `[dvwa]`)                    |
| `[dvwa][version]`                 | String  | DVWA version to deploy (default: `v1.0.8`)                                  |
| `[dvwa][path]`                    | String  | Path where application will be deployed (default: `/opt/dvwa`)              |
| `[dvwa][security_level]`          | String  | DVWA default security level (default: `high`)                               |

Usage
-----
#### dvwa::default

Just include `dvwa` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[dvwa]"
  ]
}
```

For PostgreSQL support, you need to include some extras recipes:
```json
{
  "name":"my_node",
  "run_list": [
    "recipe[postgresql::apt_pgdg_postgresql]",
    "recipe[postgresql::client]",
    "recipe[dvwa::pg_omnibus]",
    "recipe[dvwa::gem_pg]",
    "recipe[postgresql::server]",
    "recipe[dvwa]"
  ],
  "attributes": {
    "postgresql": {
      "password": {
        "postgres": "postgres"
      }
    },
    "dvwa": {
      "db": {
        "use_pgsql": true
      }
    }
  }
}
```

#### Running tests

- First, install dependencies:  
`bundle install`

- Run Checkstyle and ChefSpec:  
`bundle exec rake`

- Run Kitchen tests:  
`bundle exec rake kitchen`  

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add-component-x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Sliim <sliim@mailoo.org> 

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
