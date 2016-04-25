require 'rails_helper'

RSpec.describe SummaryController, type: :controller do
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
        expect(response.body).to match(/<td class="flagged"><a href="\/ossec\/example">2<\/a><\/td>/)
        expect(response.body).to match(/<td class="flagged"><a href="\/advisories\/example">1<\/a><\/td>/)
        expect(response.body).to match(/<td>9.3 - Critical<\/td>/)
      end

      context 'displays only flagged servers' do
        before do
          stub_const('ApplicationController::YAML_DIR', 'spec/data/')
          get :index, show_only_flagged: 1
        end
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_with_layout :application }
        it { is_expected.to render_template :index }

        it "gets the right output" do
          # Only one host.
          expect(response.body).to match(/<td><a href="\/server\/example">example</)
          expect(response.body).not_to match(/<td><a href="\/server\/test">test</)

          # And the flagged data for it again.
          expect(response.body).to match(/<td class="flagged"><a href="\/ossec\/example">2<\/a><\/td>/)
          expect(response.body).to match(/<td class="flagged"><a href="\/advisories\/example">1<\/a><\/td>/)
          expect(response.body).to match(/<td>9.3 - Critical<\/td>/)
        end
      end
    end
  end
end
