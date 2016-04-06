namespace :cache do
  desc 'Load our cache of server advisories'
  task advisories: :environment do
    # TODO: Having some trouble calling the other ruby app directly, so for
    #       now I'm instead having it generate a file via cron and this just
    #       copy it into place.

    # Default settings.
    cachefile = '/var/lib/systems-dashboard/advisories.yaml'
    source = '/home/reporting/advisories.yaml'

    FileUtils.copy(source, cachefile)
  end
end
