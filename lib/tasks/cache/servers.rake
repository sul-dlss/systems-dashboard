namespace :cache do
  desc 'Load our cache of base server information'
  task servers: :environment do
    Cache::Servers.new.cache
  end
end
