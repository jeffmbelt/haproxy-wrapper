# InSpec test for recipe haproxy_wrapper::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe package('haproxy') do
  it { should be_installed }
end

describe file('/etc/haproxy/haproxy.cfg') do
  it { should exist }
end

describe upstart_service('haproxy') do
  it { should be_enabled }
  it { should be_running }
end
