class AdvisoriesController < ApplicationController
  require 'yaml'

  def show
    @host = params[:id]
    unless /\.stanford\.edu$/ =~ @host
      @host <<'.stanford.edu'
    end

    advisories = YAML.load_file('/var/lib/systems-dashboard/advisories.yaml')
    if advisories.key?(@host)
      @advisories = advisories[@host]
    else
      @advisories = {}
    end
  end
end
