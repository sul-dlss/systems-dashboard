class DetailsController < ApplicationController
  def index
    categories = %w(general vmware vault)
    records = Server.includes(:details).where(details: { category: categories })
    @servers = convert_yaml(records)
  end
end
