# Parse a CSV download of our hardware firewall information and format it by
# hostname.
namespace :download do
  desc 'Download YAML of hardware firewall lookups'
  task firewall: :environment do
    require 'ipaddr'
    require 'csv'

    # Default settings.
    cachefile = '/var/lib/systems-dashboard/firewall.yaml'
    csvfile = '/var/lib/systems-dashboard/sulair2_FirewallRules.csv'
    servercache = '/var/lib/systems-dashboard/servers.yaml'

    # Mappings of network zones to the IP ranges within those zones.
    @zone_maps = {
        'webapp-dev-rstr' => ['171.67.35.128/25', '171.67.23.0/24'],
        'webapp-restrict' => ['171.67.35.0/25', '171.67.21.0/24'],
        'webapp' => ['171.67.34.0/24', '172.27.34.0/24', '171.67.45.0/24'],
        'db-restrict' => ['172.20.206.128/25'],
        'db-dev-restrict' => ['172.20.207.0/25'],
        'stucomp' => ['171.67.43.192/27', '172.27.43.192/27'],
        'mgmt' => ['171.67.33.192/27', '172.20.192.0/23'],
        'sdr-priv' => ['171.67.8.224/27', '172.20.194.0/24'],
    }

    def in_network_range?(zones, ranges, host_ip)
      host_addr = IPAddr.new(host_ip)

      # If there are specific zones given, only match if the host is in one
      # of those zones.
      unless zones.nil? || zones.count == 0 || zones.include?('any')
        match = 0
        zones.each do |z|
          next unless @zone_maps.key?(z)
          @zone_maps[z].each do |zone_ips|
            zone_addr = IPAddr.new(zone_ips)
            match = 1 if zone_addr.include?(host_addr)
          end
        end
        return false unless match == 1
      end

      # Now see if the host is in any of the actual network ranges given.
      ranges.each do |r|
        return true if r == 'any'
        range_addr = IPAddr.new(r)
        return true if range_addr.include?(host_addr)
      end

      false
    end

    # Get our hostnames from the servers file.
    serverdata = YAML.load_file(servercache)
    hosts = serverdata.keys

    firewalls = {}
    hosts.each do |hostname|
      begin
        host_ip = IPSocket.getaddress(hostname)
      rescue SocketError
        # TODO: Log instead.
        STDERR.puts "Could not get IP for #{hostname}"
        next
      end
      rules = []

      csvdata = CSV.open(csvfile, { skip_lines: '^Generated at', headers: true })
      csvdata.each do |row|
        src_zone = row[4].split(/[\r\n]+/)
        dst_zone = row[5].split(/[\r\n]+/)
        src_addr = row[7].split(/[\r\n]+/)
        dst_addr = row[10].split(/[\r\n]+/)

        if in_network_range?(src_zone, src_addr, host_ip) || in_network_range?(dst_zone, dst_addr, host_ip)
          rule = {}
          rule['src_zone'] = src_zone
          rule['dst_zone'] = dst_zone
          rule['src_addr'] = src_addr
          rule['dst_addr'] = dst_addr
          rule['ports'] = row[13].split(/[\r\n]+/)
          rule['status'] = row[16]
          rules << rule
        end
      end

      firewalls[hostname] = rules
    end

    output = YAML.dump(firewalls)
    File.write(cachefile, output)

    Cache::Firewall.new.cache
  end
end
