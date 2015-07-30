module VagrantPlugins
  module JsonConfig
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :project
      def initialize
        @project = UNSET_VALUE

        config_file = Dir.pwd + '/projects.json'

        if File.exist?(config_file)
          file = File.read(config_file)
          projects = JSON.parse(file)

          if ENV['PROJECT_KEY'] && projects[ENV['PROJECT_KEY']]
            @project = projects[ENV['PROJECT_KEY']]
          else
            raise Vagrant::Errors::PluginLoadError, message: "This JsonConfig plugin requires the env variable PROJEKT_KEY to be set and a corresponding entry has to be existent in your projects.json file."
          end
        end
      end
    end
  end
end
