


include_recipe "sensu::rabbitmq"
include_recipe "sensu::redis"

include_recipe "sensu_wrapper::worker"

include_recipe "sensu::api_service"
include_recipe "uchiwa_wrapper"

include_recipe "sensu_wrapper::wizardvan"
include_recipe "sensu_wrapper::checks"


