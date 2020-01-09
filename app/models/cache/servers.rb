class Cache
  class Servers
    CACHEFILE = '/var/lib/systems-dashboard/servers.yaml'.freeze

    def cache
      require 'yaml'
      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      servers = YAML.load_file(CACHEFILE)

      import_details = []
      servers.keys.each do |hostname|
        # For now we're just suppressing anything that belongs to an separate
        # interface.  In the longer term if we have useful information to report
        # on them, like firmware updates, model the best way to merge that data
        # with the owning host.
        next if hostname =~ /-(ips|sp)[-\.]/
        next if hostname =~ /-(private|webapp|restrict-prod|unicorn)\./
        next if hostname =~ /^(coursework|cw).+-(cwdev|webapp|cwprd)\./

        serverrec = Server.find_or_create_by(hostname: hostname)
        server_id = serverrec.id

        servers[hostname].keys.each do |type|
          if type == 'alive' || type == 'cobbler' || type == 'puppetdb'
            value = servers[hostname][type]
            import_details << [server_id, 'general', type, value]
          elsif type == 'netdb' || type == 'vmware'
            servers[hostname][type].keys.each do |subtype|
              value = servers[hostname][type][subtype]
              if subtype == 'aliases' || subtype == 'addresses' || subtype == 'custom'
                value = value.to_yaml
              end

              import_details << [server_id, type, subtype, value]
            end
          end
        end
      end

      # Clear existing fields.  General ends up getting a few fields from
      # the advisories, so we only remove specific fields.
      delete_types = %w(netdb vmware)
      Detail.where(category: delete_types).delete_all
      Detail.where(category: 'general', name: %w(alive cobbler puppetdb)).delete_all
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
