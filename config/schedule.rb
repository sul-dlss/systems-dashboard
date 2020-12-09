# Use this file to easily define all of your cron jobs.
#
# Example:
#
# set :output, "/path/to/my/cron_log.log"
#

# This is fairly low-resource so do it often to push out updates as quickly
# as possible.
every '*/10 * * * *' do
  rake 'download:servers'
end

# Puppet facts and state are fairly low resource.
every '*/10 * * * *' do
  rake 'download:puppetfacts'
  rake 'download:puppetstatus'
end
