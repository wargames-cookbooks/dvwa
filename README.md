DVWA Cookbook
=============
Deploy a Damn Vulnerable Web Application environment.
[![Cookbook Version](https://img.shields.io/cookbook/v/dvwa.svg)](https://community.opscode.com/cookbooks/dvwa) [![Build Status](https://secure.travis-ci.org/wargames-cookbooks/dvwa.png)](http://travis-ci.org/wargames-cookbooks/dvwa)

Requirements
------------

#### Platform
- `Ubuntu 10.04`
- `Ubuntu 12.04`
- `CentOS 6.4`

#### Cookbooks
- `apache2` - https://github.com/opscode-cookbooks/apache2.git
- `mysql` - https://github.com/opscode-cookbooks/mysql.git
- `php` - https://github.com/opscode-cookbooks/php.git
- `database` - https://github.com/opscode-cookbooks/database.git

Attributes
----------

#### dvwa::default
* `['dvwa']['db']['use_psql']` - Use Postgresql instead MySQL
* `['dvwa']['db']['port']` - >Database port, only needed for postgresql dbms
* `['dvwa']['db']['name']` - Database name
* `['dvwa']['db']['username']` - Database user name
* `['dvwa']['db']['password']` - Database user password
* `['dvwa']['recaptcha']['public_key']` - Recaptcha public key
* `['dvwa']['recaptcha']['private_key']` - Recaptcha private key
* `['dvwa']['apache2']['server_name']` - Apache2 server name
* `['dvwa']['apache2']['server_aliases']` - Array of apache2 virtualhost aliases
* `['dvwa']['version']` - DVWA version to deploy
* `['dvwa']['path']` - Path where application will be deployed
* `['dvwa']['security_level']` - DVWA default security level

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

#### Running tests

- First, install dependencies:  
`bundle install`  

- Install cookbook dependencies  
`berks install`  

- Run strainer tests:  
`bundle exec strainer test`  

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
