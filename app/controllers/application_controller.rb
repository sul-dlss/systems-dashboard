class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  YAML_DIR = '/var/lib/systems-dashboard/'.freeze
  YAML_FIELDS = { 'netdb'      => [ 'aliases', 'addresses' ],
                  'managed'    => [ 'files' ],
                }.freeze
  INT_FIELDS  = { 'nessus'     => [ 'total' ] 
                }.freeze
  NUM_FIELDS  = { }.freeze

  require 'yaml'

  # Use a list of special fields to format fields that should either be
  # converted from YAML, or which should be in a specific field type.
  def format_value(category, field, value)
    if YAML_FIELDS.key?(category) && YAML_FIELDS[category].include?(field)
      return {} if value.nil?
      return YAML.load(value)
    elsif INT_FIELDS.key?(category) && INT_FIELDS[category].include?(field)
      return {} if value.nil?
      return value.to_i
    elsif NUM_FIELDS.key?(category) && NUM_FIELDS[category].include?(field)
      return {} if value.nil?
      return value.to_f
    end

    value
  end

  # Take a number of server/detail records for hosts, then format it into a
  # data structure with standardized fields for display.
  def convert_yaml(servers)
    serverdata = {}
    servers.each do |server|
      hostname = server.hostname

      # Initialize our root fields so that there won't be any surprises from
      # hosts that don't have data.
      serverdata[hostname] = {}
      fields = %w(general netdb puppetfacts puppetstatus vmware managed nessus)
      fields.each do |root|
        serverdata[hostname][root] = {}
      end

      server.details.each do |detail|
        category = detail.category
        field = detail.name
        value = format_value(category, field, detail.value)
        serverdata[hostname][category][field] = value
      end
    end
    serverdata
  end
end
