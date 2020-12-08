# Get a list of puppet facts associated with servers and write to yaml.
# Borrowed in part from https://github.com/sul-dlss/puppetdb_reporter/
namespace :download do
  desc 'Download YAML of puppet facts'
  task puppetfacts: :environment do
    require 'puppetdb'
    require 'yaml'
    require 'no_proxy_fix'

    facts = %w(department technical_team user_advocate project sla_level
               environment iptables github_url lsbdistdescription
               apache_installed mysql_installed rvm_installed rvm_version
               passenger_installed)

    def get_fact_value(hostname, fact_name)
      response = @client.request('facts', ['and',
                                           ['=', 'certname', hostname],
                                           ['=', 'name', fact_name]])
      response.data.collect { |x| x['value'] }.first
    end

    # Default settings.
    @client = PuppetDB::Client.new({:server => 'http://sulpuppet-db.stanford.edu:8080'})
    cachefile = '/var/lib/systems-dashboard/facts.yaml'

    # Get all hostnames.
    hosts = {}
    response = @client.request('facts', ['=', 'name', 'hostname'])
    response.data.each do |r|
      hostname = r['certname']
      hosts[hostname] = {}
    end

    # Now for each host find all the facts for that host.
    hosts.keys.each do |hostname|
      facts.each do |fact|
        hosts[hostname][fact] = get_fact_value(hostname, fact)
      end
    end

    output = YAML.dump(hosts)
    File.write(cachefile, output)

#    Cache::Puppetfacts.new.cache
  end
end
