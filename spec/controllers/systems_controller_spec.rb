require 'rails_helper'

RSpec.describe SystemsController, type: :controller do
  fixtures :servers
  fixtures :details
  require 'yaml'
  describe 'GET #index' do
    context 'displays a list of all servers' do
      before do
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
        expect(response.body).to match(/<td>production</)

        expect(response.body).to match(/<td>dlss</)
        expect(response.body).to match(/<td>Julian</)
        expect(response.body).to match(/<td>low</)
        expect(response.body).to match(/<td>testing</)
      end
    end
  end
end
