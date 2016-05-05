namespace :cache do
  desc 'Load our cache of ossec file warning information'
  task ossec: :environment do
    Cache::Ossec.new.cache
  end
end
