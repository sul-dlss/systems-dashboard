namespace :cache do
  desc 'Load our cache of server advisories'
  task advisories: :environment do
    require "#{Rails.root}/app/helpers/application_helper"
    include ApplicationHelper

    require 'open3'
    require 'yaml'

    # Default settings.
    summaryfile = '/var/lib/systems-dashboard/advisories-summary.yaml'
    reportsdir = '/var/lib/systems-dashboard/advisories/'
    server = 'sulreports.stanford.edu'
    args = %w{advisories report:feeder}
    command = '/usr/bin/k5start -qUtf /etc/keytabs/service.sul-reports.keytab -- /usr/bin/remctl ' + server + ' ' + args.join(' ')

    # Run the remctl and handle output problems.
    output, error, status = Open3.capture3(command)
    if status != 0
      raise "command failed: #{error}"
    elsif output == ''
      raise "no output: #{error}"
    end

    # The advisories file is large enough to cause speed problems with the
    # dashboard.  Go through and separate it out by server, with summary data
    # saved for the main page.
    servers = YAML.load(output)
    summary = {}
    servers.keys.each do |host|
      fname = reportsdir + host + '.yaml'
      serverdata = YAML.dump(servers[host])
      File.write(fname, serverdata)

      # Calculate the summary count and highest patch severity for the server.
      summary[host] = {}
      summary[host]['count'] = servers[host].keys.count
      summary[host]['highest'] = 0
      servers[host].keys.each do |package|
        servers[host][package].keys.each do |version|
          servers[host][package][version].each do |advisory|
            severity_level = cvss_text_to_score(advisory['severity'])
            cached_level = summary[host]['highest']
            next if cached_level >= severity_level
            summary[host]['highest'] = severity_level
          end
        end
      end
    end

    # Write a summary file of the high level information, for speed.
    File.write(summaryfile, YAML.dump(summary))
  end
end
