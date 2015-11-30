

plugin_directory = "#{node["sensu"]["directory"]}/plugins"

sensu_check "disk-check" do
  command "#{plugin_directory}/check-disk.rb -w 90 -c 95"
  handlers ["default"]
  subscribers ["all"]
  interval 120
end


%w[
 kafka
 redis
 elasticsearch
 sql
].each do |service|
sensu_check "#{service}-check" do
  command "#{plugin_directory}/check-process.sh -p #{service}"
  handlers ["default"]
  subscribers ["#{service}"]
  interval 120
end
end

sensu_check "redis-memory-check" do
  command "#{plugin_directory}/check-redis-memory.rb -w 0.80 -c 0.90"
  handlers ["default"]
  subscribers ["redis"]
  interval 120
end

sensu_check "es-cluster-check" do
  command "#{plugin_directory}/check-es-cluster-status.rb"
  handlers ["default"]
  subscribers ["elasticsearch"]
  interval 120
end

sensu_check "es-fd-check" do
  command "#{plugin_directory}/check-es-file-descriptors.rb -w 80 -c 90"
  handlers ["default"]
  subscribers ["elasticsearch"]
  interval 120
end

sensu_check "es-heap-check" do
  command "#{plugin_directory}/check-es-heap.rb -w 80 -c 90 -P"
  handlers ["default"]
  subscribers ["elasticsearch"]
  interval 120
end

sensu_check "sql-connections-check" do
  command "#{plugin_directory}/mysql-connections.rb -u root -p admin -s /var/run/mysql-sql/mysqld.sock -w 90 -c 95"
  handlers ["default"]
  subscribers ["sql"]
  interval 120
end

%w[
  cpu-pcnt-usage-metrics
  memory-pcnt-metrics
  disk-usage-metrics
].each do |metric|
sensu_check "#{metric}" do
  type "metric"
  command "#{plugin_directory}/#{metric}.rb"
  handlers ["relay"]
  subscribers ["all"]
  interval 120
  additional(
    :output_type => "graphite",
    :auto_tag_host => "yes"
  )
end
end

sensu_check "es-node-metrics" do
  type "metric"
  command "#{plugin_directory}/es-node-metrics.rb"
  handlers ["relay"]
  subscribers ["elasticsearch"]
  interval 120
  additional(
    :output_type => "graphite",
    :auto_tag_host => "yes"
  )
end

sensu_check "redis-metrics" do
  type "metric"
  command "#{plugin_directory}/redis-metrics.rb"
  handlers ["relay"]
  subscribers ["redis"]
  interval 120
  additional(
    :output_type => "graphite",
    :auto_tag_host => "yes"
  )
end


sensu_check "mesos-master-metrics" do
  type "metric"
  command "#{plugin_directory}/mesos-metrics.rb -m master"
  handlers ["relay"]
  subscribers ["hadoop_namenode_mesos"]
  interval 120
  additional(
    :output_type => "graphite",
    :auto_tag_host => "yes"
  )
end

sensu_check "mesos-slave-metrics" do
  type "metric"
  command "#{plugin_directory}/mesos-metrics.rb -m slave"
  handlers ["relay"]
  subscribers ["hadoop_datanode_mesos"]
  interval 120
  additional(
    :output_type => "graphite",
    :auto_tag_host => "yes"
  )
end
