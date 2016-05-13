# Get a list of puppet statuses, things that can require extra processing from
# facts.
namespace :download do
  desc 'Download YAML of puppet state'
  task puppetstatus: :environment do
    require 'open3'

    # Default settings.
    cachefile = '/var/lib/systems-dashboard/puppetstate.yaml'
    command = '/opt/app/reports/systeam-reporting/puppet-reports --yaml'

    # Actually run the remctl command and handle output, saving to file.
    output, error, status = Open3.capture3(command)
    if status != 0
      raise "command failed: #{error}"
    end
    if output == ''
      raise "no output: #{error}"
    else
      File.write(cachefile, output)
      Cache::Puppetstatus.new.cache
    end
  end
end
