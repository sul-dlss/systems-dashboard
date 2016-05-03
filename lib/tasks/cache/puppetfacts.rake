# Get a list of puppet facts associated with servers and write to yaml.
# Borrowed in part from https://github.com/sul-dlss/puppetdb_reporter/
namespace :cache do
  desc 'Load our cache of puppet facts'
  task puppetfacts: :environment do
    Cache::Puppetfacts.new.cache
  end
end
