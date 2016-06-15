class UpgradesController < ApplicationController
  def show
    @host = params[:id]
    @host << '.stanford.edu' unless /\.stanford\.edu$/ =~ @host

    records = Server.where('hostname' => @host).includes(:details)
                    .where('details.category' => 'upgrades')
    all_upgrades = convert_yaml(records)
    @advisories = if records.count == 0
                    nil
                  elsif all_upgrades[@host]['upgrades']['packages'].nil?
                    nil
                  else
                    all_upgrades
                  end
  end
end
