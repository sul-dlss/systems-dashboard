namespace :download do
  desc 'Download YAML of ossec file warning information'
  task ossec: :environment do
    require 'open3'

    # Default settings.
    cachefile = '/var/lib/systems-dashboard/ossec.yaml'
    server = 'sul-ossec.stanford.edu'
    args_update = %w{ossec update}
    args_download = %w{ossec status}

    # Update the cache of data before download.
    command = '/usr/bin/k5start -qUtf /etc/keytabs/service.sul-reports.keytab -- /usr/bin/remctl ' + server + ' ' + args_update.join(' ')
    output, error, status = Open3.capture3(command)
    if status != 0
      raise "command failed: #{error}"
    end

    # Now get the data and save to file.
    command = '/usr/bin/k5start -qUtf /etc/keytabs/service.sul-reports.keytab -- /usr/bin/remctl ' + server + ' ' + args_download.join(' ')
    output, error, status = Open3.capture3(command)
    if status != 0
      raise "command failed: #{error}"
    end
    if output == ''
      raise "no output: #{error}"
    else
      File.write(cachefile, output)
      Cache::Ossec.new.cache
    end
  end
end
