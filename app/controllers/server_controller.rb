# This handles the view of miscellaneous information for a specific server.
class ServerController < ApplicationController
  require 'yaml'

  def show
    @host = params[:id]
    unless /\.stanford\.edu$/ =~ @host
      @host <<'.stanford.edu'
    end
    shorthost = @host.sub(/\.stanford\.edu$/, '')

    # Load our data from the source files.
    servers = YAML.load_file('/var/lib/systems-dashboard/servers.yaml')
    advisories = YAML.load_file('/var/lib/systems-dashboard/advisories-summary.yaml')
    ossec = YAML.load_file('/var/lib/systems-dashboard/ossec.yaml')
    firewall = YAML.load_file('/var/lib/systems-dashboard/firewall.yaml')
    puppetstate = YAML.load_file('/var/lib/systems-dashboard/puppetstate.yaml')
    facts = YAML.load_file('/var/lib/systems-dashboard/facts.yaml')

    @server = {}
    @server['base'] = servers[shorthost]
    @server['advisories'] = advisories[@host]
    @server['firewall'] = firewall[shorthost]
    @server['puppetstate'] = puppetstate[@host]
    @server['facts'] = facts[@host]
    @server['ossec'] = ossec[@host]
  end
end
