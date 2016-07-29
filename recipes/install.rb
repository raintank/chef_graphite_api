#
# Cookbook Name:: chef_graphite_api
# Recipe:: graphite_raintank
#
# Copyright (C) 2015 Raintank, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

packagecloud_repo node[:chef_base][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['chef_graphite_api']['package_version']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "memcached"

package "graphite-metrictank" do
  version pkg_version
  action pkg_action
end

group "graphite" do
  members "graphite"
  system
  action :create
end

directory "/var/lib/graphite" do
  owner "graphite"
  group "graphite"
  mode "0755"
  recursive true
  action :create
end

directory node['chef_graphite_api']['log_dir'] do
  owner "graphite"
  group "graphite"
  mode "0755"
  recursive true
  action :create
end

service "graphite-raintank" do
  action [ :enable, :start ]
end

elasticsearch_host = find_haproxy || node['chef_graphite_api']['elasticsearch_host']
tank_host = find_haproxy || node['chef_graphite_api']['tank_host']
cassandras = find_cassandras
if cassandras.empty?
  cassandras = node['chef_graphite_api']['cassandras']
end

template "/etc/graphite-metrictank.yaml" do
  source 'graphite-metrictank.yaml.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  variables({
    finders: node['chef_graphite_api']['finders'],
    functions: node['chef_graphite_api']['functions'],
    cassandras: cassandras,
    tank_host: tank_host,
    tank_port: node['chef_graphite_api']['metrictank']['listen'].sub(/^:/, ""),
    elasticsearch_host: elasticsearch_host,
    elasticsearch_port: node['chef_graphite_api']['elasticsearch_port'],
    search_index: node['chef_graphite_api']['search_index'],
    time_zone: node['chef_graphite_api']['time_zone'],
    use_statsd: node['use_statsd'],
    statsd_host: node['chef_graphite_api']['statsd_host'],
    statsd_port: node['chef_graphite_api']['statsd_port'],
    log_level: node['chef_graphite_api']['log_level'],
    log_dir: node['chef_graphite_api']['log_dir'],
    index_name: node['chef_graphite_api']['metrictank']['index_name'],
    use_cache: node['chef_graphite_api']['use_cache'],
    cache_ttl: node['chef_graphite_api']['cache_ttl'],
    cache_dir: node['chef_graphite_api']['cache_dir'],
    cache_servers: node['chef_graphite_api']['cache_servers'],
    cache_type: node['chef_graphite_api']['cache_type']
  })
  notifies :restart, 'service[graphite-raintank]'
end

tag("graphite-api")
