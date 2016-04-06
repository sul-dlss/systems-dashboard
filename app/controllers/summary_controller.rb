# This handles reporting methods, only taking the data that's already in the
# database and presenting it for various functions.
class SummaryController < ApplicationController
  require 'yaml'

  def index
    # Set options for viewing.
    @options = {}
    if params['show_only_flagged']
      @options['show_only_flagged'] = 1
    end

    # Load our data from the source files.
    base = YAML.load_file('lib/assets/servers.yaml')
    advisories = YAML.load_file('lib/assets/advisories.yaml')
    ossec = YAML.load_file('lib/assets/ossec.yaml')

    # Flags will be marked on any host that has a field or fields that have
    # actionable data.  It will mirror the main servers hash separately.
    @flags = {}

    advisories.keys.each do |host|
      shorthost = host.sub(/\.stanford\.edu$/, '')
      next unless base.key?(shorthost)
      base[shorthost]['advisories'] = advisories[host].keys.count
    end

    ossec.keys.each do |host|
      shorthost = host.sub(/\.stanford\.edu$/, '')
      next unless base.key?(shorthost)
      base[shorthost]['ossec'] = ossec[host]['changed'].keys.count
    end

    # Check for any flagged fields.
    base.keys.each do |host|
      @flags[host] = {}
      if flag_positive?(base[host]['ossec'])
        @flags[host]['ossec'] = 1
      end
      if flag_positive?(base[host]['advisories'])
        @flags[host]['advisories'] = 1
      end
      if flag_cobbler_only?(base[host])
        @flags[host]['cobbler'] = 1
      end
    end

    @servers = base
  end

  # Flag for any field that should never actually have a count on it.
  def flag_positive? (count)
    return false if count.nil?
    return true if count > 0
    return false
  end

  # Checks to see if a server is set up only in cobbler and in nothing else.
  def flag_cobbler_only? (server)
    return false unless server.key?('cobbler')
    return false if server.key?('netdb')
    return false if server.key?('vmware')
    return false if server.key?('puppetdb')

    return true
  end

end
