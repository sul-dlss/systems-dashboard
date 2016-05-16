require 'rails_helper'

RSpec.describe SoftwareController, type: :controller do
  fixtures :servers
  fixtures :details
  require 'yaml'
  describe 'GET #index' do
    context 'displays a list of all servers' do
      before do
        stub_const('SoftwareController::GEMNASIUMFILE', 'spec/data/gemnasium.yaml')
        get :index
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :index }

      it "gets the right output" do
        # Two hosts.
        expect(response.body).to match(/<td><a href="\/server\/example">example</)
        expect(response.body).to match(/<td><a href="\/server\/test">test</)

        # For the first host, several fields that should show.
        expect(response.body).to match(/<td>RHEL 5.5</)
        expect(response.body).to match(/<td>production</)
        expect(response.body).to match(/<td><a href='https:\/\/github.com\/sul-dlss\/superspecial.git' target='_blank'>sul-dlss\/superspecial<\/a></)
        expect(response.body).to match(/<td><a href='https:\/\/gemnasium.com\/github.com\/sul-dlss\/superspecial\/alerts' target='_blank'>3<\/a></)
        expect(response.body).to match(/<td>2.0<br \/>2.2</)

        expect(response.body).to match(/<td>RHEL 5.5</)
        expect(response.body).to match(/<td>1.9</)
      end
    end
  end
end
