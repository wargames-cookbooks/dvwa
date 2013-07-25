DVWA Cookbook
=============
Deploy a Damn Vulnerable Web Application environment.

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
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['dvwa']['db']['use_psql']</tt></td>
    <td>Boolean</td>
    <td>Use Postgresql instead MySQL</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['db']['port']</tt></td>
    <td>Integer</td>
    <td>Database port, only needed for postgresql dbms</td>
    <td><tt>5432</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['db']['name']</tt></td>
    <td>String</td>
    <td>Database name</td>
    <td><tt>dvwa</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['db']['username']</tt></td>
    <td>String</td>
    <td>Database user name</td>
    <td><tt>dvwa</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['db']['password']</tt></td>
    <td>String</td>
    <td>Database user password</td>
    <td><tt>dvwa</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['recaptcha']['public_key']</tt></td>
    <td>String</td>
    <td>Recaptcha public key</td>
    <td><tt>6LfzKeUSAAAAABbGMjVS77HmkY7emIB9v5VGeEvb</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['recaptcha']['private_key']</tt></td>
    <td>String</td>
    <td>Recaptcha private key</td>
    <td><tt>6LfzKeUSAAAAAEPD91_3uUGaemNs9ZNehkccBOoF</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['apache2']['server_name']</tt></td>
    <td>String</td>
    <td>Apache2 server name</td>
    <td><tt>dvwa</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['apache2']['server_aliases']</tt></td>
    <td>String</td>
    <td>Array of apache2 virtualhost aliases</td>
    <td><tt>dvwa</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['version']</tt></td>
    <td>String</td>
    <td>DVWA version to deploy</td>
    <td><tt>v1.0.8</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['path']</tt></td>
    <td>String</td>
    <td>Path where application will be deployed</td>
    <td><tt>/opt/dvwa</tt></td>
  </tr>
  <tr>
    <td><tt>['dvwa']['security_level']</tt></td>
    <td>String</td>
    <td>DVWA default security level</td>
    <td><tt>high</tt></td>
  </tr>
</table>

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

- Run kitchen tests:  
`bundle exec kitchen test`  

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

License: See COPYING file.
