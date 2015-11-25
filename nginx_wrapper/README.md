nginx_wrapper Cookbook
======================
This cookbook is for installing nginx as a proxy on AWS

Requirements
------------
#### packages
- `nginx` - nginx_wrapper needs nginx cookbook from chef supermarket

Attributes
----------

#### nginx_wrapper::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['nginx']['default_site_enabled']</tt></td>
    <td>Boolean</td>
    <td>whether to enable the default site</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### nginx_wrapper::default

Just include `nginx_wrapper` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[nginx_wrapper]"
  ]
}
```

License and Authors
-------------------
Authors: Zhenyu
