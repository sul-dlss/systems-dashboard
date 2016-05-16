require 'rails_helper'

RSpec.describe OssecController, type: :controller do
  fixtures :servers
  fixtures :details
  require 'yaml'
  describe 'GET #index' do
    context 'displays a list of all ossec changed files for each server' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :index
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :index }

      it "gets the right output" do
        expect(response.body).to match(/<td>example<\/td>/)
        expect(response.body).to match(/<td>test<\/td>/)
        expect(response.body).to match(/2016-03-31/)
        expect(response.body).to match(/2016-03-18/)
        expect(response.body).to match(/\/etc\/sysctl\.conf: 2016-03-31 17:38:04 -0700/)
        expect(response.body).to match(/\/etc\/mcollective\/facts\.yaml: 2016-03-21 11:23:43 -0700/)
      end
    end
  end

  describe 'GET #show' do
    context 'displays a list of all ossec changed files for one server' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, id: 'example.stanford.edu'
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :show }

      it "gets the right output" do
        expect(response.body).to match(/<td>example<\/td>/)
        expect(response.body).to match(/2016-03-31/)
        expect(response.body).to match(/2016-03-18/)
        expect(response.body).to match(/\/etc\/sysctl\.conf: 2016-03-31 17:38:04 -0700/)
        expect(response.body).to match(/\/etc\/mcollective\/facts\.yaml: 2016-03-21 11:23:43 -0700/)
      end
    end

    context 'displays an error for a server with no ossec changed files' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, id: 'test.stanford.edu'
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :show }

      it "gets the right output" do
        expect(response.body).to match(/No changed files found/)
      end
    end

    context 'displays an error for a server that does not exist' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, id: 'doesnotexist.stanford.edu'
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :show }

      it "gets the right output" do
        expect(response.body).to match(/No information found for /)
      end
    end
  end
end
