require 'rails_helper'
RSpec.describe SummaryHelper, type: :helper do
  describe "#expired_host" do
    it "returns true when given empty server" do
      server = {}
      expect(helper.expired_host(server)).to eq true
    end
    it "returns true when given server with only upgrades data" do
      server = {}
      server['vmware'] = {}
      server['ossec'] = {}
      server['upgrades'] = {}
      server['upgrades']['date'] = 'yes'
      expect(helper.expired_host(server)).to eq true
    end
    it "returns false when given server with only upgrades data" do
      server = {}
      server['vmware'] = {}
      server['ossec'] = {}
      server['upgrades'] = {}
      server['upgrades']['date'] = 'yes'
      server['vmware']['template'] = 'sure'
      expect(helper.expired_host(server)).to eq false
    end
  end
end
