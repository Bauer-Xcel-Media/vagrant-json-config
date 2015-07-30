begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant JsonConfig config plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.2.0"
  raise "The Vagrant JsonConfig config plugin is only compatible with Vagrant 1.2+"
end

module VagrantPlugins
  module JsonConfig
    class Plugin < Vagrant.plugin("2")
      name "JsonConfig"
      description <<-DESC
        Vagrant plugin to load configuration values from json config
      DESC

      config "jsonconfig" do
        require_relative "config"
        Config
      end
    end
  end
end
