require 'rails_helper'

RSpec.describe ServerController, type: :controller do
  fixtures :servers
  fixtures :details
  require 'yaml'
  describe 'GET #show' do
    context 'displays status for a server' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, params: { id: 'example.stanford.edu' }
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
        expect(response.body).to match(/<td>Host Aliases<\/td>\s+<td>example2<br \/>example3</)
        expect(response.body).to match(/<td>IPs<\/td>\s+<td>192.168.1.3<br \/>192.168.1.4</)
        expect(response.body).to match(/<td>Model \(netdb\)<\/td>\s+<td>Raspberry Pi</)
        expect(response.body).to match(/<td>OS \(netdb\)<\/td>\s+<td>Linux-Redhat</)
        expect(response.body).to match(/Last puppet run failed/)
        expect(response.body).to match(/Puppet has not run lately, last run at /)
        expect(response.body).to match(/<td>environment<\/td>\s+<td>production</)
        expect(response.body).to match(/lotsofiptablesinfo/)
      end
    end

    context 'displays status for a server with different information' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, params: { id: 'test.stanford.edu' }
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
        expect(response.body).not_to match(/<td>Host Aliases<\/td>/)
        expect(response.body).to match(/<td>IPs<\/td>\s+<td>192.168.1.5</)
        expect(response.body).to match(/<td>Model \(netdb\)<\/td>\s+<td>TRS80 Coco2</)
        expect(response.body).to match(/<td>OS \(netdb\)<\/td>\s+<td>Linux-Centos</)
        expect(response.body).to match(/Last run successful/)
        expect(response.body).to match(/<td>department<\/td>\s+<td>dlss</)
        expect(response.body).to match(/<td>environment<\/td>\s+<td>production</)
        expect(response.body).to match(/<td>project<\/td>\s+<td>testing</)
        expect(response.body).to match(/<td>sla_level<\/td>\s+<td>low</)
        expect(response.body).to match(/<td>technical_team<\/td>\s+<td>dlss</)
        expect(response.body).to match(/<td>user_advocate<\/td>\s+<td>Julian</)
        expect(response.body).to match(/No iptables data found from puppet./)
      end
    end

    context 'displays error for server that does not exist' do
      before do
        stub_const('ApplicationController::YAML_DIR', 'spec/data/')
        get :show, params: { id: 'doesnotexist.stanford.edu' }
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
