class AdvisoriesController < ApplicationController
  require 'yaml'

  def show
    @host = params[:id]
    @host << '.stanford.edu' unless /\.stanford\.edu$/ =~ @host

    records = Server.where('hostname' => @host).includes(:details)
                    .where('details.category' => 'advisories')
    all_advisories = convert_yaml(records)
    if records.count == 0 || all_advisories[@host]['advisories']['details'].nil?
      @advisories = nil
    else
      @advisories = all_advisories
    end
  end
end
