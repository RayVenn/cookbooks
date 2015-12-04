

default["sensu"]["admin_user"] = "root"
default["sensu"]["directory"] = "/vol/sensu"
default["sensu"]["log_directory"] = "/vol/sensu/logs"
default["sensu"]["version"] = "0.20*"
default["sensu"]["use_unstable_repo"] = false
default["sensu"]["log_level"] = "info"
default["sensu"]["use_ssl"] = false
default["sensu"]["use_embedded_ruby"] = true
default["sensu"]["init_style"] = "sysv"

default["sensu_wrapper"]["use_local_ipv4"] = false
default["sensu_wrapper"]["environment_aware_search"] = false
default["sensu_wrapper"]["master_address"] = nil
default["sensu_wrapper"]["default_handlers"] = ["debug", "slack"]
default["sensu_wrapper"]["metric_handlers"] = ["debug"]
default["sensu_wrapper"]["sensu_plugin_version"] = "1.1.0"
