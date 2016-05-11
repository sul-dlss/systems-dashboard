require 'rails_helper'
RSpec.describe PuppetHelper, type: :helper do
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

  describe '#gemnasium_url' do
    it "returns '-' for a nil project" do
      expect(helper.gemnasium_url(nil, nil)).to eq '-'
    end
    it "returns '-' for a badly formatted project" do
      project = 'https://not.github.com/whatever'
      expect(helper.gemnasium_url(project, nil)).to eq '-'
    end
    it "returns '-' for a project not in gemnasium" do
      project = 'https://github.com/sul-dlss/whatever.git'
      gemnasium = { 'sul-dlss/not-whatever' => [ 1, 2, 3 ] }
      expect(helper.gemnasium_url(project, gemnasium)).to eq '-'
    end
    it "returns correct url for a good project" do
      project = 'https://github.com/sul-dlss/whatever.git'
      gemnasium = { 'sul-dlss/whatever' => [ 1, 2, 3 ] }
      url = "<a href='https://gemnasium.com/github.com/sul-dlss/whatever/alerts' target='_blank'>3</a>"
      expect(helper.gemnasium_url(project, gemnasium)).to eq url
    end
    it "returns correct url for a good project with no alerts" do
      project = 'https://github.com/sul-dlss/whatever.git'
      gemnasium = { 'sul-dlss/whatever' => [] }
      url = "<a href='https://gemnasium.com/github.com/sul-dlss/whatever' target='_blank'>0</a>"
      expect(helper.gemnasium_url(project, gemnasium)).to eq url
    end

  end
end
