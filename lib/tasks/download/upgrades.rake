namespace :download do
  desc 'Update list of pending server upgrades'
  task upgrades: :environment do
    Cache::Upgrades.new.cache
  end
end
