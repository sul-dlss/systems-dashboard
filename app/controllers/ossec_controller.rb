# Displays both view of all ossec changed files, and those for individual
# servers.
class OssecController < ApplicationController
  def index
    require 'yaml'

    categories = %w(ossec managed)
    records = Server.where('hostname' => @host).includes(:details)
                    .where(details: { category: categories })
    @ossec = convert_yaml(records)
  end

  def show
    @host = params[:id]
    @host << '.stanford.edu' unless /\.stanford\.edu$/ =~ @host

    categories = %w(ossec managed)
    records = Server.where('hostname' => @host).includes(:details)
                    .where(details: { category: categories })
    @ossec = convert_yaml(records)
  end
end
