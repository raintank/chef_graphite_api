module ChefGraphiteApi
  module Helpers
    def find_haproxy
      return nil? unless node.attribute?('gce')
      zone = node['gce']['instance']['zone']
      haproxy = search("node", node['chef_base']['haproxy_search'])
      h = haproxy.select { |h| h['gce']['instance']['zone'] == zone }.first
      return (h) ? h.ipaddress : nil
    end
    def find_cassandras
      if Chef::Config[:solo] || node['chef_base']['standalone']
         return [ "127.0.0.1" ]
      end
      cassandras = search("node", node['chef_base']['cassandra_search'])
      return cassandras.map { |c| c.fqdn }
    end
  end
end

Chef::Recipe.send(:include, ::ChefGraphiteApi::Helpers)
Chef::Resource.send(:include, ::ChefGraphiteApi::Helpers)
Chef::Provider.send(:include, ::ChefGraphiteApi::Helpers)
