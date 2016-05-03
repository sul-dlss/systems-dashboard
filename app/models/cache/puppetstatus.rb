class Cache
  class Puppetstatus
    CACHEFILE = '/var/lib/systems-dashboard/puppetstate.yaml'.freeze

    def cache
      require 'yaml'
      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      puppetstatus = YAML.load_file(CACHEFILE)

      import_details = []
      puppetstatus.keys.each do |hostname|
        serverrec = Server.find_or_create_by(hostname: hostname)
        server_id = serverrec.id

        puppetstatus[hostname].keys.each do |type|
          value = puppetstatus[hostname][type]
          import_details << [server_id, 'puppetstatus', type, value]
        end
      end

      delete_types = %w(puppetstatus)
      Detail.delete_all(category: delete_types)
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
