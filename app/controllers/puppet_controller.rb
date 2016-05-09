class PuppetController < ApplicationController
  require 'yaml'

  def index
    # Set options for viewing.
    @opt = {}
    @opt['show_only_flagged'] = 1 if params['show_only_flagged']

    # Find all data except for the advisory details, as that contains a lot of
    # data sometimes.  Potentially we could reverse this and look for specific
    # fields, but there are a lot of fields we care about.
    records = Server.includes(:details)
      .where(details: {category: %w(general puppetfacts)})
    @servers = convert_yaml(records)
  end
end
