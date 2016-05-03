# This handles the view of miscellaneous information for a specific server.
class ServerController < ApplicationController
  require 'yaml'

  def show
    @host = params[:id]
    @host << '.stanford.edu' unless /\.stanford\.edu$/ =~ @host

    records = Server.where('hostname' => @host).includes(:details)
    if records.nil? || records.count == 0
      @server = nil
    else
      # Convert the YAML and then make sure we have some defaults set.
      @server = convert_yaml(records)
    end
  end
end
