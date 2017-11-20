#
# Cookbook Name:: litc-glds-nsclient
# Recipe:: passwdless_auth_linux
#
# Copyright 2017, SAP labs
#
# All rights reserved - Do Not Redistribute
#
names = Dir.entries('/home')
names.each do |usernames|

linux_regex_key = ''

linux_user_key = ''

directory "/home/#{usernames}/.ssh" do
  user usernames
  mode '0755'
  recursive true
  action :create
end

file "/home/#{usernames}/.ssh/authorized_keys" do
  mode '0600'
  owner 'gldsshs'
end

ruby_block 'add entry in to authorized keys file' do
  block do
    file = Chef::Util::FileEdit.new("/home/#{usernames}/.ssh/authorized_keys")
    file.insert_line_if_no_match(/(#{linux_regex_key})/, linux_user_key)
    file.write_file
  end
  only_if { Mixlib::ShellOut.new("grep '#{linux_regex_key}' \"/home/#{usernames}/.ssh/authorized_keys\"").run_command.stdout.empty? }
end

end