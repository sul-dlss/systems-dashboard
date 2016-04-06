namespace :cache do
  desc 'Load our cache of server advisories'
  task advisories: :environment do
    # TODO: Having some trouble calling the other ruby app directly, so for
    #       now I'm instead having it generate a file via cron and this just
    #       copy it into place.

    # Default settings.
    cachefile = 'lib/assets/advisories.yaml'
    source = '/home/reporting/advisories.yaml'

    File.copy(source, cachefile)
  end
end
