class Cache
  class Puppetstatus < Cache
    CACHEFILE = '/var/lib/systems-dashboard/puppetstate.yaml'.freeze

    def cache
      require 'yaml'
      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      puppetstatus = YAML.load_file(CACHEFILE)

      import_details = []
      puppetstatus.keys.each do |hostname|
        canonical = canonical_host(hostname)
        serverrec = Server.find_or_create_by(hostname: canonical)
        server_id = serverrec.id

        puppetstatus[hostname].keys.each do |type|
          value = puppetstatus[hostname][type]
          import_details << [server_id, 'puppetstatus', type, value]
        end
      end

      delete_types = %w(puppetstatus)
      Detail.where(category: delete_types).delete_all
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
