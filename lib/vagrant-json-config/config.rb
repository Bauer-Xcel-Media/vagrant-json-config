require 'pathname'

module VagrantPlugins
  module JsonConfig
    class Config < Vagrant.plugin("2", :config)

      # The complete data as JSON object
      #
      # @deprecated use function get(key) instead
      #
      # @return Hash
      attr_accessor :data

      def initialize
        @data = UNSET_VALUE
      end

      # Overrides the coresponding attr_accessor
      #
      # @deprecated use function get(key) instead
      #
      # @return Hash
      def data
        puts "DEPRECATION: Accessing data from the root element accessor is deprecated and will be removed soon."
        puts "Please use get(key) instead."
        @data
      end

      # load json data from file and extract data for the given key
      # if no key is given all the data will be loaded
      # by calling this multiple times, every subsequent data
      # will be merged in
      #
      # @raises an error if required is true but the file doeas not exists
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

      # get data from a given key
      # raises an error, if the key does not exist
      # call has?(key) to test if the key exists
      #
      # @return Hash
      def get(key)
        unless self.has?(key)
          raise Vagrant::Errors::PluginLoadError, message: "The key #{key} does not exist in ."
        end

        @data[key]
      end

      # test if a given key exists within the loaded data
      #
      # @return boolean
      def has?(key)
        @data.has_key?(key)
      end
    end
  end
end
