namespace :download do
  desc 'Download YAML showing managed files for each server'
  task managedfiles: :environment do
    Cache::Managedfiles.new.cache
  end
end
