require 'rails_helper'

RSpec.describe SummaryController, type: :controller do
  fixtures :servers
  fixtures :details
  require 'yaml'
  describe 'GET #index' do
    context 'displays a list of all servers' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
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
        expect(response.body).to match(/<td class="flagged">\s+\*\s+</)
      end

      context 'displays only flagged servers' do
        before do
          stub_const('ApplicationController::YAML_DIR', 'spec/data/')
          get :index, params: { show_only_flagged: 1 }
        end
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_with_layout :application }
        it { is_expected.to render_template :index }

        it "gets the right output" do
          # Only one host.
          expect(response.body).to match(/<td><a href="\/server\/example">example</)
          expect(response.body).not_to match(/<td><a href="\/server\/test">test</)
        end
      end
    end
  end
end
