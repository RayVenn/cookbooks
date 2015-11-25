 #Attributes for schema-repo_wrapper default cookbook
 default['schema_repo']['zip_url'] = 'https://github.com/schema-repo/schema-repo/archive/master.zip'
 default['schema_repo']['zk'] = ['10.0.14.52']
 default['schema_repo']['version'] = '1.2.9.10'
 default['schema_repo']['dir'] = '/vol/schema-repo'
 default['schema_repo']['type'] = 'file-system'
 
 #Attributes for overriding the attributes in java cookbook
 default['java']['install_flavor'] = "oracle"
 default['java']['jdk_version'] = "8" 
 default['java']['oracle']['accept_oracle_download_terms'] = true
 
 #Attributes for overriding the attributes in ark cookbook
