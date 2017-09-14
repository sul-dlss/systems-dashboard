require 'rails_helper'
RSpec.describe SoftwareHelper, type: :helper do
  # Expands a github URL into a link with short title.
  describe "#github_url" do
    it "returns empty string when given no input" do
      expect(helper.github_url(nil)).to eq ''
      expect(helper.github_url('')).to eq ''
    end
    it "links and shortens a normal github url" do
      github = 'https://github.com/sul-dlss/argo.git'
      giturl = "<a href='https://github.com/sul-dlss/argo.git' target='_blank'>sul-dlss/argo</a>"
      expect(helper.github_url(github)).to eq giturl
    end
  end

  # Cleans up the puppet full release description to something shorter.
  describe '#release' do
    it "returns empty string when given no input" do
      expect(helper.release(nil)).to eq ''
      expect(helper.release('')).to eq ''
    end
    it "strips release from a string" do
      release = 'CentOS release 6.7'
      expect(helper.release(release)).to eq 'CentOS 6.7'
    end
    it "shortens Red Hat Enterprise Linux Server to RHEL" do
      release = 'Red Hat Enterprise Linux Server 6.7'
      expect(helper.release(release)).to eq 'RHEL 6.7'
    end
    it "removes ending ($releasename)" do
      release = 'CentOS 6.7 (supercool)'
      expect(helper.release(release)).to eq 'CentOS 6.7'
    end
  end

  describe '#separate_commas' do
    it "reformats a comma-separated list" do
      string = 'test,this,string'
      expect(helper.separate_commas(string)).to eq 'test<br />this<br />string'
    end
    it "doesn't touch a normal string" do
      string = 'test this string'
      expect(helper.separate_commas(string)).to eq string
    end
  end
end
