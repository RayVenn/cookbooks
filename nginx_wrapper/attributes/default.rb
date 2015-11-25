# Attribute for nginx_wrapper::default cookbook
# These variables are not used for now, but still declared here
default['port']['max_backend'] = 9000
default['port']['max_notification'] = 9001
default['port']['max_contest'] = 9002
default['port']['max_cluster'] = 9003

# Override the attribute from nginx cookbook
default['nginx']['default_site_enabled'] = false
