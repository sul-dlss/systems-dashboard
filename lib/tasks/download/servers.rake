namespace :download do
  desc 'Download yaml of basic server information'
  task servers: :environment do
    require 'open3'

    # Default settings.
    cachefile = '/var/lib/systems-dashboard/servers.yaml'
    command = '/usr/bin/k5start -qUf /etc/keytabs/service.sul-reports.keytab -- /opt/app/reports/systeam-reporting/server-status --yaml'

    # Actually run the remctl command and handle output, saving to file.
    output, error, status = Open3.capture3(command)
    if status != 0
      raise "command failed: #{error}"
    end
    if output == ''
      raise "no output: #{error}"
    else
      File.write(cachefile, output)
      Cache::Servers.new.cache
    end
  end
end
