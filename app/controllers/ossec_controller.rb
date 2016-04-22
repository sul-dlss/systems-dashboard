# Displays both view of all ossec changed files, and those for individual
# servers.
class OssecController < ApplicationController
  def index
    @ossec = YAML.load_file(YAML_DIR + 'ossec.yaml')
  end

  def show
    @host = params[:id]
    @host << '.stanford.edu' unless /\.stanford\.edu$/ =~ @host

    @ossec = nil
    ossec_all = YAML.load_file(YAML_DIR + 'ossec.yaml')
    @ossec = ossec_all[@host] if ossec_all.key?(@host)
  end
end
