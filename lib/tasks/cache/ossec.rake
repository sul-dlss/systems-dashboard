namespace :cache do
  desc 'Load our cache of ossec file warning information'
  task ossec: :environment do
    require 'open3'

    # Default settings.
    cachefile = 'lib/assets/ossec.yaml'
    server = 'sul-ossec.stanford.edu'
    args = %w{ossec status}
    command = '/usr/bin/k5start -qUtf /etc/keytabs/service.sul-reports.keytab -- /usr/bin/remctl ' + server + ' ' + args.join(' ')

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
