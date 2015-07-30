# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-json-config/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-json-config"
  spec.version       = VagrantPlugins::JsonConfig::VERSION
  spec.authors       = ["Jan Schumann"]
  spec.email         = ["jan.schumann@bauerxcel.de"]
  spec.summary       = %q{A Vagrant plugin to set configuration variables via json.}
  spec.description   = %q{A Vagrant plugin to set configuration variables via json.}
  spec.homepage      = "https://github.com/Bauer-Xcel-Media/vagrant-json-config"
  spec.license       = "MIT"
  spec.files         = %w(README.md LICENSE.txt
                      vagrant-json-config.gemspec
                      lib/vagrant-json-config.rb
                      lib/vagrant-json-config/version.rb
                      lib/vagrant-json-config/config.rb
                      lib/vagrant-json-config/plugin.rb)
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.6"
end
