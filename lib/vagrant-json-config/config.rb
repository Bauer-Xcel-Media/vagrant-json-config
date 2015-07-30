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

          if ENV['PROJECT_KEY']
            @project = projects[ENV['PROJECT_KEY']]
          else
            raise Vagrant::Errors::PluginLoadError, message: "This JsonConfig plugin requires the env variable PROJEKT_KEY to be set to determin the projects config variables."
          end
        else
          raise Vagrant::Errors::PluginLoadError, message: "This JsonConfig plugin requires a project.json in your project dir."
        end
      end
    end
  end
end
