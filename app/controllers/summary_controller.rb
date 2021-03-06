# This handles reporting methods, only taking the data that's already in the
# database and presenting it for various functions.
class SummaryController < ApplicationController
  require 'yaml'

  def index
    # Set options for viewing.
    @opt = {}
    @opt['show_only_flagged'] = 1 if params['show_only_flagged']

    # Find all data for the catagories we care about.
    categories = %w(general puppetstatus puppetfacts vmware nessus)
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

      if hosts[host].key?('puppetstatus')
        if flag_content?(hosts[host]['puppetstatus']['too_quiet'])
          fields = %w(puppetstatus too_quiet)
          flags[host][fields] = 1
        end
        if flag_content?(hosts[host]['puppetstatus']['failed'])
          fields = %w(puppetstatus failed)
          flags[host][fields] = 1
        end
      end

      if hosts[host].key?('nessus')
        if flag_positive?(hosts[host]['nessus']['total'])
          fields = %w(nessus total)
          flags[host][fields] = 1
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
end
