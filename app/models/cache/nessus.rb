class Cache
  class Nessus < Cache

    def cache
      cachefile = '/var/lib/systems-dashboard/nessus-scan.json'.freeze

      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      require 'json'

      file = File.read(cachefile)
      nessus_data = JSON.parse(file)

      # Nessus has given multiple values for a server in the past.  These were
      # all cases with dc2-srtr* which we filter anyway, but just in case we
      # get this for regular servers, we stuff everything into a hash first to
      # remove extra lines.
      host_data = {}
      nessus_data['hosts'].each do |host|
        hostname = host['hostname']

        # Skip some things that Nessus looks up that we don't track.
        next if hostname =~ /^dc2-srtr-vl/

        host_data[hostname] = {} unless host_data.has_key?(hostname)
        host_data[hostname]['low'] = host['low']
        host_data[hostname]['medium'] = host['medium']
        host_data[hostname]['high'] = host['high']
        host_data[hostname]['critical'] = host['critical']
        host_data[hostname]['id'] = host['host_id']
      end

      # Then take the last seen and put it into an array for loading.  Unlike
      # most data pulls, we're going to skip anything that doesn't already have
      # a server record.  Nessus can send us data for multiple things we don't
      # care about, so use that as a filter.
      import_details = []
      host_data.each_key do |hostname|
        canonical = canonical_host(hostname)
        serverrec = Server.find_by(hostname: canonical)
        next if serverrec.nil?
        server_id = serverrec.id

        url = "https://dlss-sagittarius.stanford.edu/#/scans/reports/66/hosts/#{host_data[hostname]['id']}/vulnerabilities"
        total = host_data[hostname]['medium'] + host_data[hostname]['high'] + host_data[hostname]['critical']

        import_details << [server_id, 'nessus', 'low', host_data[hostname]['low']]
        import_details << [server_id, 'nessus', 'medium', host_data[hostname]['medium']]
        import_details << [server_id, 'nessus', 'high', host_data[hostname]['high']]
        import_details << [server_id, 'nessus', 'critical', host_data[hostname]['critical']]
        import_details << [server_id, 'nessus', 'url', url]
        import_details << [server_id, 'nessus', 'total', total]
      end

      # import_details.each do |line|
      #   puts line.join("\t")
      # end

      delete_types = %w(nessus)
      Detail.where(category: delete_types).delete_all
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
