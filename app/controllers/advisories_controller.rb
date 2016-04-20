class AdvisoriesController < ApplicationController
  require 'yaml'

  def show
    @host = params[:id]
    unless /\.stanford\.edu$/ =~ @host
      @host <<'.stanford.edu'
    end

    fname = '/var/lib/systems-dashboard/advisories/' + @host + '.yaml'
    if File.exists?(fname)
      @advisories = YAML.load_file(fname)
    else
      @advisories = {}
    end
  end
end
