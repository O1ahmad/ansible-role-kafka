title "Kafka service launch test suite"

require 'rspec/retry'

describe file('/etc/systemd/system/kafka.service') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
  its('content') { should match('EnvironmentFile=') }
end

describe service('kafka') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe command('/opt/kafka/bin/kafka-topics.sh --create --topic test ' \
                 '--zookeeper localhost:2181 --replication-factor 1 ' \
                 '--partitions 1') do
  its(:exit_status) { should == 0 }
end

describe command('/opt/kafka/bin/kafka-topics.sh --list --zookeeper localhost:2181') do
  its(:stdout) { should include 'test' }
end
