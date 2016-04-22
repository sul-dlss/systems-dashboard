# This handles the view of miscellaneous information for a specific server.
class ServerController < ApplicationController
  require 'yaml'

  def show
    @host = params[:id]
    @host << '.stanford.edu' unless /\.stanford\.edu$/ =~ @host
    shorthost = @host.sub(/\.stanford\.edu$/, '')

    # Load our data from the source files.
    servers = YAML.load_file(YAML_DIR + 'servers.yaml')
    advisories = YAML.load_file(YAML_DIR + 'advisories-summary.yaml')
    ossec = YAML.load_file(YAML_DIR + 'ossec.yaml')
    firewall = YAML.load_file(YAML_DIR + 'firewall.yaml')
    puppetstate = YAML.load_file(YAML_DIR + 'puppetstate.yaml')
    facts = YAML.load_file(YAML_DIR + 'facts.yaml')

    @server = nil
    if servers.key?(shorthost)
      @server = {}
      @server['base'] = servers[shorthost]
      @server['advisories'] = advisories[@host]
      @server['firewall'] = firewall[shorthost]
      @server['puppetstate'] = puppetstate[@host]
      @server['facts'] = facts[@host]
      @server['ossec'] = ossec[@host]
    end
  end
end
