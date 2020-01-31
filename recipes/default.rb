#
# Cookbook:: haproxy_wrapper
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

apt_update

all_web_servers = seach('node', 'policy_name:apache')

webserver_pool = []

all_web_servers.each do |current_node|
  webserver = {
    'hostname' => current_node['cloud']['public_hostname'],
    'ipaddress' => current_node['cloud']['public_ipv4'],
    'port' => 80,
    'ssl_port' => 80,
  }
  webserver_pool.push(webserver)
end

node.default['haproxy']['members'] = webserver_pool

include_recipe 'haproxy::manual'
