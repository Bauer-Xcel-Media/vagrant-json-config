require File.expand_path("../base", __FILE__)

require "vagrant-json-config/config"

describe VagrantPlugins::JsonConfig::Config do
  let(:json) { '{"foo":{"bar":"baz"}}' }
  let(:existing_key) { 'foo' }
  let(:non_existing_key) { 'missing' }

  let(:unset_value) { described_class.const_get("UNSET_VALUE") }

  before do
    Dir.chdir ENV["VAGRANT_CWD"]
    File.open('test.json', 'w') { |file| file.write(json) }
    File.open('test2.json', 'w') { |file| file.write('{"foo":{"foo":"faz"}}') }
    File.open('test_no_json.json', 'w') { |file| file.write('{"foo_bar_baz') }
  end

  subject { described_class.new }

  it "does nothing without calling load" do
    expect(subject.get_all).to be(unset_value)
  end

  describe "loading json data" do
    it "raises an error if a given file does not exist allthough required" do
      expect{subject.load_json "missing.json", nil, true}.to raise_error
    end

    it "accepts absolute path" do
      subject.load_json ENV["VAGRANT_CWD"] + "/test.json"

      expect(JSON.dump(subject.get_all)).to eq(json)
    end

    it "accepts relative path" do
      subject.load_json "test.json"

      expect(JSON.dump(subject.get_all)).to eq(json)
    end

    it "raises an error if a non existing key is given" do
      expect{subject.load_json "test.json", non_existing_key, true}.to raise_error
    end

    it "selects data correctly when an existing key is given" do
      subject.load_json "test.json", existing_key, true

      expect(JSON.dump(subject.get_all)).to eq('{"bar":"baz"}')
    end

    it "raises an error for non json file content" do
      expect{subject.load_json "test_no_json.json", nil, true}.to raise_error
    end
  end

  describe "retrieving json data" do
    before do
      subject.load_json "test.json", existing_key, true
    end

    it "loads correct data" do
      data = subject.get 'bar'

      expect(data).to eq("baz")
    end

    it "raises an error on non exsiting key" do
      expect{subject.get "sdcsd"}.to raise_error
    end

    it "merges json data when load_json is called multiple times" do
      subject.load_json "test.json", existing_key, true
      subject.load_json "test2.json", nil, true

      expect(JSON.dump(subject.get_all)).to eq('{"bar":"baz","foo":{"foo":"faz"}}')
    end
  end

  describe "load and retrieve data from different keys" do
    before do
      subject.load_json "test.json", existing_key, true
      subject.load_json "test2.json", existing_key, true, "key2"
    end

    it "loads correct data from the default source" do
      data = subject.get 'bar', 'default'

      expect(data).to eq("baz")
    end

    it "loads correct data from a specific source" do
      data = subject.get 'foo', 'key2'

      expect(data).to eq("faz")
    end
  end
end
