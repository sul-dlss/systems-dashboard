class DetailsController < ApplicationController
  def index
    categories = %w(general vmware)
    records = Server.includes(:details).where(details: { category: categories })
    @servers = convert_yaml(records)
  end
end
