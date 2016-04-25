class AdvisoriesController < ApplicationController
  require 'yaml'

  def show
    @host = params[:id]
    @host << '.stanford.edu' unless /\.stanford\.edu$/ =~ @host

    @advisories = nil
    fname = YAML_DIR + 'advisories/' + @host + '.yaml'
    @advisories = YAML.load_file(fname) if File.exist?(fname)
  end
end
