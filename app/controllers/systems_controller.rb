class SystemsController < ApplicationController
  def index
    records = Server.includes(:details)
      .where(details: {category: %w(general puppetfacts vmware)})
    @servers = convert_yaml(records)
  end
end
