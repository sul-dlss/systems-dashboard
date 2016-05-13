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

# This is also very low resource.
every '*/10 * * * *' do
  rake 'download:ossec'
end

# Puppet facts and state are fairly low resource.
every '*/10 * * * *' do
  rake 'download:puppetfacts'
  rake 'download:puppetstatus'
end

# Gemnasium API lookups take a bit longer to do, so only run hourly.
every :hour do
  rake 'download:gemnasium'
end

# The advisories don't actually get updated more than once a day, but
# grabbing the file is low-op and this way we don't have to care as much about
# when that update happens.
every :hour do
  rake 'download:advisories'
end

# Similarly, firewall rules are only updated weekly at best (they have to be
# downloaded and updated in puppet), but we want to make sure they're
# regenerated without thinking about it much.
every :hour do
  rake 'download:firewall'
end
