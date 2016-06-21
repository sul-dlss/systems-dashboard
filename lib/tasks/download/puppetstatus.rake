# Get a list of puppet statuses, things that can require extra processing from
# facts.
namespace :download do
  desc 'Download YAML of puppet state'
  task puppetstatus: :environment do
    require 'open3'

    # Default settings.
    cachefile = '/var/lib/systems-dashboard/puppetstate.yaml'
    command = '/opt/app/reports/systeam-reporting/puppetdb-report'

    # Actually run the remctl command and handle output, saving to file.
    output, error, status = Open3.capture3(command)
    raise "command failed: #{error}" if status != 0
    raise "no output: #{error}"      if output == ''

    File.write(cachefile, output)
    Cache::Puppetstatus.new.cache
  end
end
