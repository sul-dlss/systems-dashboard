require 'rails_helper'
RSpec.describe ApplicationHelper, type: :helper do

  # Asterisk translates various data into '' or '*'.
  describe "#asterisk" do
    it "returns an asterisk when given an array" do
      value = %w[test this array]
      expect(helper.asterisk(value)).to eq '*'
    end
    it "returns an asterisk when given a hash" do
      value = { test: 'this', array: 'here' }
      expect(helper.asterisk(value)).to eq '*'
    end
    it "returns an asterisk when given a numeric true boolean (1)" do
      value = 1
      expect(helper.asterisk(value)).to eq '*'
    end
    it "returns an empty string when given a nil value" do
      value = nil
      expect(helper.asterisk(value)).to eq ''
    end
    it "returns empty string on a random string" do
      expect(helper.asterisk('happy meal')).to eq ''
    end
    it "returns empty string on a random number" do
      expect(helper.asterisk(1892)).to eq ''
    end
  end

  # check_child performs validation on hashes that may or may not have
  # specific fields.
  describe "#check_child" do
    it "returns empty string when the parent is nil" do
      parent = nil
      child = 'foobar'
      expect(helper.check_child(parent, child)).to eq ''
    end
    it "returns empty string when the child is nil" do
      parent = {}
      child = 'foobar'
      expect(helper.check_child(parent, child)).to eq ''
    end
    it "otherwise returns the child's value" do
      parent = {}
      child = 'foobar'
      value = 'baz'
      parent[child] = value
      expect(helper.check_child(parent, child)).to eq value
    end
  end

  # status translates fields into an On/Off status.
  describe "#status" do
    it "returns an empty string if given an empty string" do
      expect(helper.status('')).to eq ''
    end
    it "returns On if given a true boolean" do
      expect(helper.status(true)).to eq 'On'
    end
    it "returns Off if given a false boolean" do
      expect(helper.status(false)).to eq 'Off'
    end
    it "returns On if given a true value" do
      expect(helper.status(1)).to eq 'On'
    end
    it "returns On if given any value" do
      expect(helper.status(0)).to eq 'On'
    end
  end

  # ossec_files translates hashes of files and file data into a string for
  # display.
  describe "#ossec_files" do
    it "returns warning if given nil" do
      changed_files = nil
      expect(helper.ossec_files(changed_files)).to eq 'No changed files found'
    end
    it "returns warning if not given a hash" do
      changed_files = 'some files'
      expect(helper.ossec_files(changed_files)).to eq 'No changed files found'
    end
    it "returns warning if given an empty hash" do
      changed_files = {}
      expect(helper.ossec_files(changed_files)).to eq 'No changed files found'
    end
    it "returns proper string if given a hash" do
      changed_files = {'file1' => 'data', 'file2' => 'otherdata'}
      expected = "file1: data\nfile2: otherdata"
      expect(helper.ossec_files(changed_files)).to eq expected
    end
    it "returns proper sorted string if given a hash" do
      changed_files = {'file99' => 'data', 'file2' => 'otherdata'}
      expected = "file2: otherdata\nfile99: data"
      expect(helper.ossec_files(changed_files)).to eq expected
    end
  end

  # date_only filters off the time from a time and date string.
  describe "#date_only" do
    it "gives an empty string if given an empty string" do
      expect(helper.date_only('')).to eq ''
    end
    it "strips a string down to just pure date if given a timestamp" do
      expect(helper.date_only('2016-01-01T15:30:00 EST')).to eq '2016-01-01'
    end
    it "catches and returns an empty string if given a bad string" do
      expect(helper.date_only('happy fun time')).to eq ''
    end
  end

  # parse_links takes space-separated URLs and makes them into links
  # separated by soft breaks.
  describe "#parse_links" do
    it "returns an empty string if the urls are nil" do
      urls = nil
      expect(helper.parse_links(urls)).to eq ''
    end
    it "splits and makes the urls actual links separated by a linebreak" do
      urls = 'http://fun.com https://sul.stanford.edu'
      expected = "<a href='http://fun.com' target='_blank'>http://fun.com</a><br /><a href='https://sul.stanford.edu' target='_blank'>https://sul.stanford.edu</a>"
      expect(helper.parse_links(urls)).to eq expected
    end
  end

  # shorthost shortens a stanford hostname for display.
  describe "#shorthost" do
    it "gives a .stanford.edu host without the qualifying domain" do
      expect(helper.shorthost('sul.stanford.edu')).to eq 'sul'
    end
    it "does not strip other host domains" do
      expect(helper.shorthost('sul.aws.com')).to eq 'sul.aws.com'
    end
    it "does not do anything to an already stripped host" do
      expect(helper.shorthost('sul')).to eq 'sul'
    end
  end

  # status_flag tells whether or not a specific field has already been flagged
  # for having a problem, returning a value to be used in CSS.
  describe "#status_flag" do
    it "doesn't flag a host with no flags" do
      flags = {}
      host = 'sul.stanford.edu'
      field = 'puppetdb'
      expect(helper.status_flag(flags, host, field)).to eq 'normal'
    end
    it "doesn't flag a host flagged for some other field" do
      flags = {}
      host = 'sul.stanford.edu'
      flags[host] = {}
      flags[host]['otherfield'] = 1
      field = 'puppetdb'
      expect(helper.status_flag(flags, host, field)).to eq 'normal'
    end
    it "flags a host that has been flagged for a field" do
      flags = {}
      host = 'sul.stanford.edu'
      flags[host] = {}
      field = 'puppetdb'
      flags[host][field] = 1
      expect(helper.status_flag(flags, host, field)).to eq 'flagged'
    end
  end
end
