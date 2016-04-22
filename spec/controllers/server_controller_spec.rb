require 'rails_helper'

RSpec.describe ServerController, type: :controller do
  require 'yaml'
  describe 'GET #show' do
    context 'displays status for a server' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, id: 'example.stanford.edu'
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :show }

      it "gets the right output" do
        expect(response.body).to match(/<td>NetDB<\/td>\s+<td>\*</)
        expect(response.body).to match(/<td>Resolves<\/td>\s+<td>\*</)
        expect(response.body).to match(/<td>Cobbler<\/td>\s+<td>\*</)
        expect(response.body).to match(/<td>PuppetDB<\/td>\s+<td>\*</)
        expect(response.body).to match(/<td>VMWare<\/td>\s+<td>\*</)
        expect(response.body).to match(/<td>Status<\/td>\s+<td>On</)
        expect(response.body).to match(/<td>Memory<\/td>\s+<td>4</)
        expect(response.body).to match(/<td>CPUs<\/td>\s+<td>8</)
        expect(response.body).to match(/Last puppet run failed/)
        expect(response.body).to match(/Puppet has not run lately, last run at /)
        expect(response.body).to match(/<td>environment<\/td>\s+<td>production</)
        expect(response.body).to match(/2016-03-31/)
        expect(response.body).to match(/\/etc\/sysctl\.conf: 2016-03-31 17:38:04 -0700/)
        expect(response.body).to match(/\/etc\/mcollective\/facts\.yaml: 2016-03-21 11:23:43 -0700/)
        expect(response.body).to match(/remctl sul-ossec.stanford.edu ossec clean example.stanford.edu/)
        expect(response.body).to match(/ping/)
      end
    end

    context 'displays status for a server with different information' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, id: 'test.stanford.edu'
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :show }

      it "gets the right output" do
        expect(response.body).to match(/<td>NetDB<\/td>\s+<td>\*</)
        expect(response.body).to match(/<td>Resolves<\/td>\s+<td>\*</)
        expect(response.body).to match(/<td>Cobbler<\/td>\s+<td>\*</)
        expect(response.body).to match(/<td>PuppetDB<\/td>\s+<td></)
        expect(response.body).to match(/<td>VMWare<\/td>\s+<td></)
        expect(response.body).to match(/<td>Status<\/td>\s+<td></)
        expect(response.body).to match(/<td>Memory<\/td>\s+<td>/)
        expect(response.body).to match(/<td>CPUs<\/td>\s+<td>/)
        expect(response.body).to match(/Last run successful/)
        expect(response.body).to match(/<td>department<\/td>\s+<td>dlss</)
        expect(response.body).to match(/<td>environment<\/td>\s+<td>production</)
        expect(response.body).to match(/<td>project<\/td>\s+<td>testing</)
        expect(response.body).to match(/<td>sla_level<\/td>\s+<td>low</)
        expect(response.body).to match(/<td>technical_team<\/td>\s+<td>dlss</)
        expect(response.body).to match(/<td>user_advocate<\/td>\s+<td>Julian</)
        expect(response.body).to match(/No changed files found/)
        expect(response.body).to match(/No firewall information found for this host/)
      end
    end

    context 'displays error for server that does not exist' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, id: 'doesnotexist.stanford.edu'
      end
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :show }

      it "gets the right output" do
        expect(response.body).to match(/Could not find any information for this host/)
      end
    end
  end
end
