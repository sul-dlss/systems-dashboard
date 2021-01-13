class Cache
  class Vaultsecrets < Cache

    require 'vault'
    require 'yaml'

    CACHEFILE  = '/var/lib/systems-dashboard/vault.json'.freeze
    TOKEN_FILE = '/var/lib/systems-dashboard/vault.token'.freeze
    SERVER     = 'https://vault.sul.stanford.edu/'.freeze

    # Recursive lookup to drill down on any servers that have sub-paths for values.
    def recursive_list(path)
      secrets = []
      Vault.logical.list(path).sort.each do |item|
        fullitem = "#{path}#{item}"
        if item =~ /\/$/
          secrets.push(recursive_list(fullitem))
        else
          secrets.push(fullitem)
        end
      end

      secrets
    end

    def cache()
      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      token = File.read(TOKEN_FILE).chomp

      Vault.address = SERVER
      Vault.token   = token

      servers = {}
      Vault.with_retries(Vault::HTTPConnectionError) do
        Vault.logical.list('puppet').sort.each do |hostname|
          next unless hostname =~ /\.stanford\.edu\/$/;
          hostname.gsub!(/\//, '')
          servers[hostname] = recursive_list("puppet/#{hostname}/")
        end
      end

      # Save a json file for debugging and consistency with other caches.
      File.open(CACHEFILE, 'w') do |f|
        f.write(servers.to_yaml)
      end

      # Take the vault results and save as rows for importing to the database.
      import_details = []
      servers.each_key do |hostname|
        canonical = canonical_host(hostname)
        serverrec = Server.find_by(hostname: canonical)
        next if serverrec.nil?
        server_id = serverrec.id

        import_details << [server_id, 'vault', 'secrets', servers[hostname].sort.to_yaml]
      end

      # Delete all old vault records and insert the new versions.
      delete_types = %w(vault)
      Detail.where(category: delete_types).delete_all
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end

  end
end
