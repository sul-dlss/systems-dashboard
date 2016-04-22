# Displays both view of all ossec changed files, and those for individual
# servers.
class OssecController < ApplicationController
  def index
    @ossec = YAML.load_file(YAML_DIR + 'ossec.yaml')
  end

  def show
    @host = params[:id]
    unless /\.stanford\.edu$/ =~ @host
      @host <<'.stanford.edu'
    end

    ossec_all = YAML.load_file(YAML_DIR + 'ossec.yaml')
    if ossec_all.key?(@host)
      @ossec = ossec_all[@host]
    else
      @ossec = nil
    end
  end
end
