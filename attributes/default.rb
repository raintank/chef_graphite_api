default[:use_statsd] = true
default[:chef_graphite_api][:finders] = [ 'graphite_metrictank.RaintankFinder' ]
default[:chef_graphite_api][:functions] = [ 'graphite_api.functions.SeriesFunctions', 'graphite_api.functions.PieFunctions' ]
default[:chef_graphite_api][:cassandras] = []
default[:chef_graphite_api][:tank_host] = "localhost"
default[:chef_graphite_api][:elasticsearch_host] = "localhost"
default[:chef_graphite_api][:elasticsearch_port] = 9200
default[:chef_graphite_api][:search_index] = "/var/lib/graphite/index"
default[:chef_graphite_api][:time_zone] = "UTC"
default[:chef_graphite_api][:use_statsd] = false
default[:chef_graphite_api][:statsd_host] = "localhost"
default[:chef_graphite_api][:statsd_port] = 8125
default[:chef_graphite_api][:log_level] = "INFO"
default[:chef_graphite_api][:log_dir] = "/var/log/graphite"
default[:chef_graphite_api][:cache_ttl] = 60
default[:chef_graphite_api][:use_cache] = false
default[:chef_graphite_api][:cache_dir] = "/tmp/graphite-api-cache"
default[:chef_graphite_api][:cache_servers] = ["127.0.0.1:11211"]
default[:chef_graphite_api][:cache_type] = "filesystem"
default[:chef_graphite_api][:metrictank][:listen] = "18763"
default[:chef_graphite_api][:metrictank][:index_name] = "metric"
default[:chef_graphite_api][:bind_addr] = "0.0.0.0:8888"
default[:chef_graphite_api][:worker_class] = "eventlet"
default[:chef_graphite_api][:error_log] = "#{node[:chef_graphite_api][:log_dir]}/graphite-metrictank.log"
default[:chef_graphite_api][:multi_tenant] = true
