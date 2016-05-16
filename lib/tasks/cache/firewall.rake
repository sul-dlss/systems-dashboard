# Parse a CSV download of our hardware firewall information and format it by
# hostname.
namespace :cache do
  desc 'Load our cache of hardware firewall lookups'
  task firewall: :environment do
    Cache::Firewall.new.cache
  end
end
