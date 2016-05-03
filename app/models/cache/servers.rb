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
        serverrec = Server.find_or_create_by(hostname: hostname)
        server_id = serverrec.id

        servers[hostname].keys.each do |type|
          if type == 'alive' || type == 'cobbler' || type == 'puppetdb'
            value = servers[hostname][type]
            import_details << [server_id, 'general', type, value]
          elsif type == 'netdb'
            aliases = servers[hostname][type].to_yaml
            import_details << [server_id, type, 'aliases', aliases]
          elsif type == 'vmware'
            servers[hostname][type].keys.each do |vmkey|
              value = servers[hostname][type][vmkey]
              import_details << [server_id, type, vmkey, value]
            end
          end
        end
      end
      delete_types = %w(netdb vmware)
      Detail.delete_all(category: delete_types)
      Detail.delete_all(category: 'general', name: %w(alive cobbler puppetdb))
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
