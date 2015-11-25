artifactory_wrapper Cookbook
=============

This cookbook is for setting up the artifactory in Max2 Inc.

------------

#### Other cookbook
- `artifactory` - An upstream cookbook for installing artifactory
- `java` - Java cookbook for installing JRE8 environment

Attributes
----------

#### test::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['artifactory']['zip_url']</tt></td>
    <td>String</td>
    <td>url for downloading artifactory</td>
    <td><tt>https://dl.bintray.com/jfrog/artifactory/jfrog-artifactory-oss-4.2.0.zip</tt></td>
  </tr>
  <tr>
    <td><tt>['artifactory']['zip_checksum']</tt></td>
    <td>String</td>
    <td>sha256sum for artifactory</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['artifactory']['home']</tt></td>
    <td>String</td>
    <td>home directory for artifactory</td>
    <td><tt>/vol/artifactory</tt></td>
  </tr>
  <tr>
    <td><tt>['artifactory']['log_dir']</tt></td>
    <td>String</td>
    <td>directory for artifactory logs</td>
    <td><tt>/vol/artifactory/logs</tt></td>
  </tr>
  <tr>
    <td><tt>['artifactory']['user']</tt></td>
    <td>String</td>
    <td>user for artifactory</td>
    <td><tt>artifactory</tt></td>
  </tr>
  <tr>
    <td><tt>['artifactory']['port']</tt></td>
    <td>Integer</td>
    <td>port for artifactory</td>
    <td><tt>8081</tt></td>
  </tr>
  <tr>
    <td><tt>['java']['jdk_version']</tt></td>
    <td>Integer</td>
    <td>version of JDK</td>
    <td><tt>8</tt></td>
  </tr>
</table>

Usage
-----
#### test::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `test` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[artifactory_wrapper]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
