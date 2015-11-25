# Attributes for artifactory::default cookbook
default['artifactory']['zip_url'] = 'https://dl.bintray.com/jfrog/artifactory/jfrog-artifactory-oss-4.2.0.zip'
default['artifactory']['zip_checksum'] =                                            '13bf200f0a75ee67aeec25979fe6a99bcf7f1018b08ad681c33436a149dab7cc'
default['artifactory']['home'] = '/vol/artifactory'
default['artifactory']['log_dir'] = '/vol/artifactory/logs'
default['artifactory']['catalina_base'] = ::File.join(artifactory['home'], 'tomcat')
default['artifactory']['java']['xmx'] = '1g'
default['artifactory']['java']['xms'] = '512m'
default['artifactory']['java']['extra_opts'] = '-XX:+UseG1GC'

default['artifactory']['user'] = 'artifactory'
default['artifactory']['port'] = 8081
default['artifactory']['shutdown_port'] = 8015
default['artifactory']['install_java'] = true

# Attribute for java::default cookbook
default['java']['install_flavor'] = "oracle"
default['java']['jdk_version'] = "8"
default['java']['oracle']['accept_oracle_download_terms'] = true
