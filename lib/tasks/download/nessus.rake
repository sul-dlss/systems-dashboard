# Download the nessus status via its API.
namespace :download do
  desc 'Download JSON for Nessus scan status'
  task nessus: :environment do
    require 'open-uri'
    require 'openssl'
    require 'yaml'

    # Default settings.
    cachefile = '/var/lib/systems-dashboard/nessus-scan.json'
    configfile = '/var/lib/systems-dashboard/nessus-config.yaml'

    # Load sensitive data, and data that might change (nessus host and scan id)
    # from a puppet-managed file.
    config_contents = File.open(configfile).read
    config = YAML.load(config_contents)

    url = "https://#{config['host']}/scans/#{config['scan_id']}"

    File.open(cachefile, "wb") do |file|
      file.write open(
        url,
        {
          ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
          "X-ApiKeys" => "accessKey=#{config['access_key']}; secretKey=#{config['secret_key']}"
        }
      ).read
    end

    Cache::Nessus.new.cache
  end
end
