class Cache
  class Managedfiles < Cache
    SERVER_FILES = '/var/cache/managed-files/*.yaml'.freeze

    def cache
      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      import_details = []
      Dir.glob(SERVER_FILES).sort.each do |yaml_file|
        m = /^.+\/(.+)\.yaml$/.match(yaml_file)
        next if m.nil?
        hostname = m[1]

        canonical = canonical_host(hostname)
        serverrec = Server.find_or_create_by(hostname: canonical)
        server_id = serverrec.id

        # We could just load the file contents directly rather than parsing the
        # yaml and then converting it back, but this way we do get a failure if
        # the file contents are invalid yaml.
        server = YAML.load(File.open(yaml_file))
        import_details << [server_id, 'managed', 'files', server.to_yaml]
      end

      delete_types = %w(managed)
      Detail.where(category: delete_types).delete_all
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
