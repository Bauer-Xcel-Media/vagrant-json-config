require File.expand_path("../base", __FILE__)

require "vagrant-json-config/config"

describe VagrantPlugins::JsonConfig::Config do
  let(:json) { '{"foo":{"bar":"baz"}}' }
  let(:exsiting_key) { 'foo' }
  let(:non_existing_key) { 'missing' }

  let(:unset_value) { described_class.const_get("UNSET_VALUE") }

  before do
    Dir.chdir ENV["VAGRANT_CWD"]
    File.open('test.json', 'w') { |file| file.write(json) }
  end

  subject { described_class.new }

  it "does nothing without calling load" do
    expect(subject.data).to be(unset_value)
  end

  describe "loading json data" do
    it "raises an error if a given file does not exsit" do
      expect{subject.load_json "missing.json"}.to raise_error
    end

    it "accepts absolute path" do
      subject.load_json ENV["VAGRANT_CWD"] + "/test.json"

      expect(JSON.dump(subject.data)).to eq(json)
    end

    it "accepts relative path" do
      subject.load_json "test.json"

      expect(JSON.dump(subject.data)).to eq(json)
    end

    it "raises an error if a non existing key is given" do
      expect{subject.load_json "test.json", non_existing_key}.to raise_error
    end

    it "selects data correctly when an existing key is given" do
      subject.load_json "test.json", exsiting_key

      expect(JSON.dump(subject.data)).to eq('{"bar":"baz"}')
    end

  end

  describe "retriving json data" do
    before do
      subject.load_json "test.json", exsiting_key
    end

    it "loads correct data" do
      data = subject.get 'bar'

      expect(data).to eq("baz")
    end

    it "raises an error on non exsiting key" do
      expect{subject.get non_existing_key}.to raise_error
    end
  end

end
