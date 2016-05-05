require 'rails_helper'

RSpec.describe 'ossec/index.html.erb' do
  fixtures :servers
  fixtures :details
  require 'yaml'

  # Just make sure it doesn't crash if given no reports, everything else done
  # in the controller.
  it 'displays no ossec reports correctly' do
    @ossec = {}
    render
    expect(rendered).to match(/To clear these changes/)
  end
end
