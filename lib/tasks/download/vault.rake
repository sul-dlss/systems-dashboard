# Download data from vault and then cache it in the database.
namespace :download do
  desc 'Download vault data'
  task vault: :environment do
    Cache::Vaultsecrets.new.cache
  end
end
