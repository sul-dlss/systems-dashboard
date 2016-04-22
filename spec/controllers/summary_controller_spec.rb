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
        expect(response.body).to match(/<td>example<\/td>/)
        expect(response.body).to match(/<a href="\/advisories\/example">1<\/a>/)
        expect(response.body).to match(/<a href="\/ossec\/example">2<\/a>/)
        expect(response.body).to match(/<td>1: Critical<\/td>/)
        expect(response.body).to match(/<td>test<\/td>/)
      end

      context 'displays a list of all servers' do
        before do
          stub_const('ApplicationController::YAML_DIR', 'spec/data/')
          get :index, show_only_flagged: 1
        end
        it { is_expected.to respond_with :ok }
        it { is_expected.to render_with_layout :application }
        it { is_expected.to render_template :index }

        it "gets the right output" do
          expect(response.body).to match(/<td>example<\/td>/)
          expect(response.body).to match(/<a href="\/advisories\/example">1<\/a>/)
          expect(response.body).to match(/<a href="\/ossec\/example">2<\/a>/)
          expect(response.body).to match(/<td>1: Critical<\/td>/)
          expect(response.body).not_to match(/<td>test<\/td>/)
        end
      end
    end
  end
end
