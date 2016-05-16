class Cache
  class Firewall
    CACHEFILE = '/var/lib/systems-dashboard/firewall.yaml'.freeze

    def cache
      require 'yaml'
      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      import_details = []
      firewalls = YAML.load_file(CACHEFILE)
      firewalls.keys.each do |hostname|
        serverrec = Server.find_or_create_by(hostname: hostname)
        server_id = serverrec.id

        value = firewalls[hostname].to_yaml
        import_details << [server_id, 'firewall', 'rules', value]
      end

      delete_types = %w(firewall)
      Detail.delete_all(category: delete_types)
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
