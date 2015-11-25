#Attributes for kafka-manager_wrapper default cookbook
default['kafka_manager']['zip_url'] = 'https://github.com/yahoo/kafka-manager/archive/master.zip'
default['kafka_manager']['zk'] = ['10.0.14.52']
default['kafka_manager']['version'] = '1.2.9.10'
default['kafka_manager']['dir'] = '/opt/kafka-manager'

#Attributes for overriding the attributes in java cookbook
default['java']['install_flavor'] = "oracle"
default['java']['jdk_version'] = "8"
default['java']['oracle']['accept_oracle_download_terms'] = true

#Attributes for overriding the attributes in ark cookbook
