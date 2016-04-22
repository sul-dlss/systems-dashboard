# This handles reporting methods, only taking the data that's already in the
# database and presenting it for various functions.
class SummaryController < ApplicationController
  require 'yaml'

  def index
    # Set options for viewing.
    @opt = {}
    if params['show_only_flagged']
      @opt['show_only_flagged'] = 1
    end

    # Load our data from the source files.
    base = YAML.load_file(YAML_DIR + 'servers.yaml')
    advisories = YAML.load_file(YAML_DIR + 'advisories-summary.yaml')
    ossec = YAML.load_file(YAML_DIR + 'ossec.yaml')
    puppetstate = YAML.load_file(YAML_DIR + 'puppetstate.yaml')

    # Flags will be marked on any host that has a field or fields that have
    # actionable data.  It will mirror the main servers hash separately.
    @flags = {}

    advisories.keys.each do |host|
      shorthost = host.sub(/\.stanford\.edu$/, '')
      next unless base.key?(shorthost)
      base[shorthost]['advisories'] = {}
      base[shorthost]['advisories']['count'] = advisories[host]['count']
      base[shorthost]['advisories']['highest'] = advisories[host]['highest']
    end

    ossec.keys.each do |host|
      shorthost = host.sub(/\.stanford\.edu$/, '')
      next unless base.key?(shorthost)
      if ossec[host]['changed']
        base[shorthost]['ossec'] = ossec[host]['changed'].keys.count
      else
        base[shorthost]['ossec'] = 0
      end
    end

    puppetstate.keys.each do |host|
      shorthost = host.sub(/\.stanford\.edu$/, '')
      next unless base.key?(shorthost)
      base[shorthost]['puppetstate'] = puppetstate[host]
    end

    # Check for any flagged fields.
    base.keys.each do |host|
      @flags[host] = {}
      if flag_positive?(base[host]['ossec'])
        @flags[host]['ossec'] = 1
      end
      if base[host].key?('advisories') && flag_positive?(base[host]['advisories']['count'])
        @flags[host]['advisories'] = {}
        @flags[host]['advisories']['count'] = 1
      end
      if flag_cobbler_only?(base[host])
        @flags[host]['cobbler'] = 1
      end
      if base[host].key?('puppetstate')
        if flag_content?(base[host]['puppetstate']['too_quiet'])
          @flags[host]['puppetstate'] = {}
          @flags[host]['puppetstate']['too_quiet'] = 1
        end
        if flag_content?(base[host]['puppetstate']['failed'])
          @flags[host]['puppetstate'] = {} unless @flags[host].key?('puppetstate')
          @flags[host]['puppetstate']['failed'] = 1
        end
      end
    end

    @servers = base
  end

  # Flag for any field that should only be either nil or ''.
  def flag_content? (value)
    return false if value.nil?
    return false if value == ''
    return true
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
