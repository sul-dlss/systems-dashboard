class Cache
  class Puppetfacts < Cache
    CACHEFILE = '/var/lib/systems-dashboard/facts.yaml'.freeze

    def cache
      require 'yaml'
      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      hosts = YAML.load_file(CACHEFILE)

      import_details = []
      hosts.keys.each do |hostname|
        canonical = canonical_host(hostname)
        serverrec = Server.find_or_create_by(hostname: canonical)
        server_id = serverrec.id

        hosts[hostname].keys.each do |type|
          value = hosts[hostname][type]
          import_details << [server_id, 'puppetfacts', type, value]
        end
      end

      delete_types = %w(puppetfacts)
      Detail.delete_all(category: delete_types)
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
