namespace :cache do
  desc 'Load our cache of server advisories'
  task advisories: :environment do
    Cache::Advisories.new.cache
  end
end
