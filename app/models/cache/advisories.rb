class Cache
  class Advisories < Cache
    CACHEFILE = '/var/lib/systems-dashboard/advisories.yaml'.freeze

    def cache
      require 'yaml'
      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      # The advisories file is large enough to cause speed problems with the
      # dashboard.  Go through and separate it out by server, with summary data
      # saved for the main page.
      servers = YAML.load_file(CACHEFILE)
      summary = {}
      import_details = []
      servers.keys.each do |host|
        canonical = canonical_host(host)
        serverrec = Server.find_or_create_by(hostname: canonical)
        server_id = serverrec.id

        serverdata = YAML.dump(servers[host])
        import_details << [server_id, 'advisories', 'details', serverdata]

        # Calculate the summary count and highest patch severity for the server.
        summary[host] = {}
        summary[host]['count'] = servers[host].keys.count
        summary[host]['highest'] = 0
        servers[host].keys.each do |package|
          servers[host][package].keys.each do |version|
            servers[host][package][version].each do |advisory|
              severity_level = ApplicationController.helpers
                .cvss_text_to_score(advisory['severity'])
              cached_level = summary[host]['highest']
              next if cached_level >= severity_level
              summary[host]['highest'] = severity_level
            end
          end
        end

        # The details both get saved as general rather than advisories, just
        # to simplify database lookups later by avoiding the rather heavy
        # lookup for advisory details.
        import_details << [server_id, 'general', 'advisory-count',
                           summary[host]['count']]
        import_details << [server_id, 'general', 'advisory-highest',
                           summary[host]['highest']]
      end

      Detail.delete_all(category: 'advisories')
      Detail.delete_all(category: 'general',
                        name: %w(advisory-count advisory-highest))
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
