require 'pathname'

module VagrantPlugins
  module JsonConfig
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :data
      def initialize
        @data = UNSET_VALUE
      end

      def load_json(file, key = nil, required = false)
        path = Pathname.new file

        unless path.absolute?
          path = Pathname.new(Dir.pwd + '/' + file)
        end

        if required
          unless path.exist?
            raise Vagrant::Errors::PluginLoadError, message: "The file #{path} does not exist."
          end
        end

        if path.exist?
          json = JSON.parse(path.read)
          if key != nil
            unless json.has_key?(key)
              raise Vagrant::Errors::PluginLoadError, message: "The key #{key} does not exist in the json data."
            end

            json = json[key]
          end

          if @data == UNSET_VALUE
            @data = json
          else
            @data = @data.merge(json)
          end
        end
      end

      def get(key)
        unless self.has?(key)
          raise Vagrant::Errors::PluginLoadError, message: "The key #{key} does not exist in ."
        end

        @data[key]
      end

      def has?(key)
        @data.has_key?(key)
      end
    end
  end
end
