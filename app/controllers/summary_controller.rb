# This handles reporting methods, only taking the data that's already in the
# database and presenting it for various functions.
class SummaryController < ApplicationController
  require 'yaml'

  def index
    # Set options for viewing.
    @opt = {}
    @opt['show_only_flagged'] = 1 if params['show_only_flagged']

    # Load our data from the source files.
    base = YAML.load_file(YAML_DIR + 'servers.yaml')
    base = load_advisories(base)
    base = load_ossec(base)
    base = load_puppetstate(base)

    # Flags will be marked on any host that has a field or fields that have
    # actionable data.  It will mirror the main servers hash separately.
    @flags = check_flags(base)

    @servers = base
  end

  # Load the advisories data and add it to the hosts.
  def load_advisories(hosts)
    advisories = YAML.load_file(YAML_DIR + 'advisories-summary.yaml')
    advisories.keys.each do |host|
      next unless hosts.key?(host)
      hosts[host]['advisories'] = {}
      hosts[host]['advisories']['count'] = advisories[host]['count']
      hosts[host]['advisories']['highest'] = advisories[host]['highest']
    end
    hosts
  end

  # Load the ossec data and add it to the hosts.
  def load_ossec(hosts)
    ossec = YAML.load_file(YAML_DIR + 'ossec.yaml')
    ossec.keys.each do |host|
      next unless hosts.key?(host)
      if ossec[host]['changed']
        hosts[host]['ossec'] = ossec[host]['changed'].keys.count
      else
        hosts[host]['ossec'] = 0
      end
    end
    hosts
  end

  # Load the puppet state data and add it to the hosts.
  def load_puppetstate(hosts)
    puppetstate = YAML.load_file(YAML_DIR + 'puppetstate.yaml')
    puppetstate.keys.each do |host|
      next unless hosts.key?(host)
      hosts[host]['puppetstate'] = puppetstate[host]
    end
    hosts
  end

  # Check all hosts for any flagged fields, returning the flags.
  def check_flags(hosts)
    flags = {}
    hosts.keys.each do |host|
      flags[host] = {}
      flags[host]['ossec'] = 1 if flag_positive?(hosts[host]['ossec'])
      flags[host]['cobbler'] = 1 if flag_cobbler_only?(hosts[host])
      if hosts[host].key?('advisories') && flag_positive?(hosts[host]['advisories']['count'])
        flags[host]['advisories'] = {}
        flags[host]['advisories']['count'] = 1
      end
      if hosts[host].key?('puppetstate')
        if flag_content?(hosts[host]['puppetstate']['too_quiet'])
          flags[host]['puppetstate'] = {}
          flags[host]['puppetstate']['too_quiet'] = 1
        end
        if flag_content?(hosts[host]['puppetstate']['failed'])
          flags[host]['puppetstate'] = {} unless flags[host].key?('puppetstate')
          flags[host]['puppetstate']['failed'] = 1
        end
      end
    end
    flags
  end

  # Flag for any field that should only be either nil or ''.
  def flag_content?(value)
    return false if value.nil?
    return false if value == ''
    true
  end

  # Flag for any field that should never actually have a count on it.
  def flag_positive?(count)
    return false if count.nil?
    return true if count > 0
    false
  end

  # Checks to see if a server is set up only in cobbler and in nothing else.
  def flag_cobbler_only?(server)
    return false unless server.key?('cobbler')
    return false if server.key?('netdb')
    return false if server.key?('vmware')
    return false if server.key?('puppetdb')

    true
  end

end
