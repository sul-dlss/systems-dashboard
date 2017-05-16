namespace :download do
  desc 'Download gemnasium data for our servers'
  task gemnasium: :environment do
    require 'rest-client'
    require 'json'
    require 'timeout'
    require 'yaml'

    apikey = File.open('config/gemnasium.api').read

    cachefile = '/var/lib/systems-dashboard/gemnasium.yaml'
    API = 'https://X:' + apikey + '@api.gemnasium.com/v1'

    # Fetch the results of an API call, with timeout checking.  The gemnasium
    # API seems a bit finicky and has a decent number of freezes.
    def fetch_api(url)
      attempts = 3
      count = 0
      data = {}
      while count <= attempts do
        success = 1
        begin
          Timeout::timeout(30) do
            data = JSON.parse(RestClient.get url, :method => :get,
                                             :ssl_verion => :TLSv1,
                                             :ssl_ciphers => ['RC4-SHA'])
          end
        rescue Timeout::Error
          success = 0
        rescue Net::HTTPRetriableError, OpenSSL::SSL::SSLError
          success = 0
          sleep(10)
        end
        break if success
        count += 1
      end
      data
    end

    # First get the IDs for every project we own.
    slugs = []
    url = API + '/projects'
    projects = JSON.parse(RestClient.get url, :method => :get,
                                         :ssl_verion => :TLSv1,
                                         :ssl_ciphers => ['RC4-SHA'])
    projects['owned'].each do |project|
      next unless project['monitored']
      slugs.push(project['slug'])
    end

    # Now look up each dependancy and dependancy alert for these projects.
    gemids = {}
    advisories = {}
    slugs.shuffle.each do |slug|
      advisories[slug] = []

      dependencies = fetch_api(API + '/projects/' + slug + '/dependencies')
      alerts = fetch_api(API + '/projects/' + slug + '/alerts')

      # Get only gems that are marked as critical.
      dependencies.each do |gem|
        next unless gem['package']['type'] == 'Rubygem'
        next unless gem['color'] == 'red'
        name = gem['package']['name']
        id = gem['id']
        gemids[id] = name
      end

      # Then get data on the actual alerts caused by those gems, using the
      # gem data to add the name of the package.
      alerts.each do |alert|
        alert['package'] = gemids[alert['dependency']['id']] || ''
        advisories[slug] << alert
      end
    end

    File.write(cachefile, advisories.to_yaml)
   end
end
