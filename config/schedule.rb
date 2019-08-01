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

# Very low resource indeed.
every '*/10 * * * *' do
  rake 'download:upgrades'
end

# The ossec update process can take a while, so only every 30m.
every '*/30 * * * *' do
  rake 'download:ossec'
end

# Puppet facts and state are fairly low resource.
every '*/10 * * * *' do
  rake 'download:puppetfacts'
  rake 'download:puppetstatus'
end

# The advisories don't actually get updated more than once a day, but
# grabbing the file is low-op and this way we don't have to care as much about
# when that update happens.
every :hour do
  rake 'download:advisories'
end
