Description
===========

HEAT template for setting up a private instance of WebPageTest on a single Windows
Server


Requirements
============
* A Heat provider that supports the following:
  * OS::Heat::RandomString
  * Rackspace::Cloud::WinServer
* An OpenStack username, password, and tenant id.
* [python-heatclient](https://github.com/openstack/python-heatclient)
`>= v0.2.8`:

```bash
pip install python-heatclient
```

We recommend installing the client within a [Python virtual
environment](http://www.virtualenv.org/).

Parameters
==========
Parameters can be replaced with your own values when standing up a stack. Use
the `-P` flag to specify a custom parameter.

* `server_hostname`: Windows Server Name (Default: webpagetest)
* `domain`: Domain to be used with WebPageTest (Default: example.com)
* `image`: Required: Server image used for all servers that are created as a part of
this deployment.
 (Default: Windows Server 2012 R2)
* `flavor`: Cloud Server size to use for the database server. Sizes refer to the
amount of RAM allocated to the server.
 (Default: 4 GB Performance)
* `wpt_username`: WPT Username for the site. A password will be randomly generated for this
account. This can not be the same as the Server Name.
 (Default: wptuser)

Outputs
=======
Once a stack comes online, use `heat output-list` to see all available outputs.
Use `heat output-show <OUTPUT NAME>` to get the value of a specific output.

* `site_wpt_password`: WPT Password 
* `server_ip`: Server IP 
* `site_domain`: Web Page Test Domain name 
* `admin_password`: Administrator Password 
* `site_wpt_user`: WPT User 

For multi-line values, the response will come in an escaped form. To get rid of
the escapes, use `echo -e '<STRING>' > file.txt`. For vim users, a substitution
can be done within a file using `%s/\\n/\r/g`.
