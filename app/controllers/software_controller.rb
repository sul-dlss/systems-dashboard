class SoftwareController < ApplicationController
  require 'yaml'

  def index
    # Set options for viewing.
    @opt = {}
    @opt['show_only_flagged'] = 1 if params['show_only_flagged']

    # Find all relevant data categories.
    records = Server.includes(:details)
      .where(details: {category: %w(general puppetfacts)})
    @servers = convert_yaml(records)
  end
end
