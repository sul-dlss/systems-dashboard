namespace :cache do
  desc 'Load our cache of server advisories'
  task advisories: :environment do
    require 'open3'

    # Default settings.
    cachefile = 'lib/assets/advisories.yaml'
    command = 'cd /home/reporting/server-reports/current && bin/rake report:feeder'

    # Actually run the remctl command and handle output, saving to file.
    output, error, status = Open3.capture3(command)
    if status != 0
      raise "command failed: #{error}"
    end
    if output == ''
      raise "no output: #{error}"
    else
      File.write(cachefile, output)
    end
  end
end
