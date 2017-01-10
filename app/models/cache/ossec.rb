class Cache
  class Ossec < Cache
    CACHEFILE = '/var/lib/systems-dashboard/ossec.yaml'.freeze

    def cache
      require 'yaml'
      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      ossec = YAML.load_file(CACHEFILE)

      import_details = []
      ossec.keys.each do |hostname|
        canonical = canonical_host(hostname)
        serverrec = Server.find_or_create_by(hostname: canonical)
        server_id = serverrec.id

        ossec[hostname].keys.each do |type|
          value = ossec[hostname][type].to_yaml
          import_details << [server_id, 'ossec', type, value]
        end
      end

      delete_types = %w(ossec)
      Detail.delete_all(category: delete_types)
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
