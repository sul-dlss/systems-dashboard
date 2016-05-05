# Get a list of puppet statuses, things that can require extra processing from
# facts.
namespace :cache do
  desc 'Load our cache of puppet state'
  task puppetstatus: :environment do
    Cache::Puppetstatus.new.cache
  end
end
