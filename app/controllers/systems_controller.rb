class SystemsController < ApplicationController
  def index
    categories = %w(general puppetfacts vmware upgrades)
    records = Server.includes(:details).where(details: { category: categories })
    @servers = convert_yaml(records)
  end
end
