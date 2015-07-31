require 'pathname'

module VagrantPlugins
  module JsonConfig
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :data
      def initialize
        @data = UNSET_VALUE
      end

      def load_json(file, key = nil)
        path = Pathname.new file

        unless path.absolute?
          path = Pathname.new(Dir.pwd + '/' + file)
        end

        unless path.file?
          raise Vagrant::Errors::PluginLoadError, message: "The file #{path} does not exist."
        end

        json = JSON.parse(path.read)

        if key == nil
          @data = json
        else
          if json[key]
            @data = json[key]
          else
            raise Vagrant::Errors::PluginLoadError, message: "The key #{key} does not exist in the json data."
          end
        end
      end

      def get(key)
        unless @data[key]
          raise Vagrant::Errors::PluginLoadError, message: "The key #{key} does not exist in the json data."
        end

        @data[key]
      end
    end
  end
end
