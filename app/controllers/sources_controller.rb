class SourcesController < ApplicationController
  require 'yaml'

  def index
    # Set options for viewing.
    @opt = {}
    @opt['show_only_flagged'] = 1 if params['show_only_flagged']

    # Find all relevant data categories.
    categories = %w(general netdb puppetstatus vmware)
    records = Server.includes(:details).where(details: { category: categories })
    @servers = convert_yaml(records)

    # Flags will be marked on any host that has a field or fields that have
    # actionable data.  It will mirror the main servers hash separately.
    @flags = check_flags(@servers)
  end

  # Check all hosts for any flagged fields, returning the flags.
  def check_flags(hosts)
    flags = {}
    hosts.keys.each do |host|
      flags[host] = {}

      errors = check_sources(hosts[host])
      next if errors == ''
      flags[host]['text'] = errors
    end
    flags
  end

  # Given a server, check it for various situations where it appears in some
  # sources but not others.
  def check_sources(server)
    return 'Not owned by DLSS' if netdb_but_not_dlss?(server)
    return 'Only in NetDB' if only_netdb?(server)
    return 'Only in VMware' if only_vmware?(server)
    return 'Old configurations need cleaning' if only_configs?(server)

    ''
  end

  def netdb_but_not_dlss?(server)
    return false unless server['netdb'].empty?
    return true if server['general']['alive'].to_i == 1

    false
  end

  def only_netdb?(server)
    return false unless server['vmware'].empty?
    return true unless server['netdb'].empty?

    false
  end

  # Is the only place we actually find the server in vmware?
  def only_vmware?(server)
    return false if server['general']['alive'].to_i == 1
    return false unless server['netdb'].empty?
    return true unless server['vmware'].empty?

    false
  end

  # Does the server only have configs remaining?  Just make sure it's not in
  # any of the main sources and assume that means there was a config.
  def only_configs?(server)
    return false if server['general']['alive'].to_i == 1
    return false unless server['netdb'].empty?
    return false unless server['vmware'].empty?

    true
  end
end
