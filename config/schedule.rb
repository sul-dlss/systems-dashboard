# Use this file to easily define all of your cron jobs.
#
# Example:
#
# set :output, "/path/to/my/cron_log.log"
#

# This is fairly low-resource so do it often to push out updates as quickly
# as possible.
every '*/10 * * * *' do
  rake 'cache:servers'
end

# This is also very low resource.
every '*/10 * * * *' do
  rake 'cache:ossec'
end

# Puppet facts are fairly low resource.
every '*/10 * * * *' do
  rake 'cache:puppetfacts'
end

# The advisories don't actually get updated more than once a day, but
# grabbing the file is low-op and this way we don't have to care as much about
# when that update happens.
every :hour do
  rake 'cache:advisories'
end

