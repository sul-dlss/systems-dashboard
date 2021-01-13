# Download data from vault and then cache it in the database.
namespace :download do
  desc 'Download vault data'
  task vault: :environment do
    Cache::Vault.new.cache
  end
end
