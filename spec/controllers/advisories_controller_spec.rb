require 'rails_helper'

RSpec.describe AdvisoriesController, type: :controller do
  describe 'GET #show' do
    context 'displays the main page with all items correctly' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, id: 'example.stanford.edu'
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :show }

      it "gets the right output" do
        expect(response.body).to match(/<td>nss-tools</)
        expect(response.body).to match(/<td>CESA-2016--0591</)
        expect(response.body).to match(/<td>Moderate</)
        expect(response.body).to match(/<td>Security Advisory</)
        expect(response.body).to match(/<td>Moderate CentOS nspr Security Update</)
        expect(response.body).to match(/https:\/\/rhn.redhat.com\/errata\/RHSA-2016-0591.html/)
      end
    end

    context 'displays error at server with no advisories' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, id: 'test.stanford.edu'
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :show }

      it "gets the right output" do
        expect(response.body).to match(/No advisories found for/)
      end
    end
    context 'displays error at invalid server' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, id: 'doesnotexist.stanford.edu'
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :show }

      it "gets the right output" do
        expect(response.body).to match(/No advisories found for/)
      end
    end
  end
end
