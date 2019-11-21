namespace :download do
  desc 'Download YAML of server advisories'
  task advisories: :environment do
    require "#{Rails.root}/app/helpers/application_helper"
    include ApplicationHelper

    require 'open3'
    require 'yaml'

    # Default settings.
    cachefile = '/var/lib/systems-dashboard/advisories.yaml'
    server = 'sulreports.stanford.edu'
    args = %w{advisories report:feeder}
    command = '/usr/bin/k5start -qUf /etc/keytabs/service.sul-reports.keytab -- /usr/bin/remctl ' + server + ' ' + args.join(' ')

    # Run the remctl and handle output problems.
    output, error, status = Open3.capture3(command)
    if status != 0
      raise "command failed: #{error}"
    elsif output == ''
      raise "no output: #{error}"
    end
    File.write(cachefile, output)

    Cache::Advisories.new.cache
  end
end
