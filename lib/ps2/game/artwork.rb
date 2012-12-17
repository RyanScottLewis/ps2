module PS2
  class Game
    
    # A Game's artwork such as the fron and back covers and CD artwork.
    class Artwork
      VALID_TYPES = %W[jpe?g png gif bmp]
      
      # The path of the artwork.
      # 
      # @return [Pathname, nil]
      attr_reader :path
      
      # The data of the artwork.
      # 
      # @return [Pathname, nil]
      attr_reader :data
      
      # Rename the given filename to the OPL standard of `game_code.name.iso`.
      #
      # @param [String, #to_s] path The filename to rename.
      # @param [Hash, #to_hash, #to_h] options The options.
      # @option options [String, #to_s] :path The path of an image file to load the data from.
      # @option options [String, #to_s] :data Set the data directly.
      # @raise [PS2::InvalidOptions] This error will be raised when the given options are invalid.
      # @raise [PS2::InvalidPath] This error will be raised when the given path is invalid.
      # @raise [PS2::PathNotFoundError] This error will be raised when the given path does not exist on the file system.
      # @raise [PS2::NotImageFileError] This error will be raised when the given path is not an image file.
      def initialize(options={})
        raise InvalidOptions.new(options) unless options.nil? || [:to_hash, :to_h].any? { |method| options.respond_to?(method) }
        options = options.to_hash rescue options.to_h unless options.is_a?(Hash)
        
        unless options[:path].nil?
          self.path = options[:path]
          
          if options[:data].nil?
            begin
              @data = @path.read
            rescue
              raise ReadError, @path
            end
          end
        end
        
        self.data = options[:data] unless options[:data].nil?
      end
      
      def path=(path)
        raise InvalidPath, path unless path.respond_to?(:to_s)
        path = Pathname.new(path.to_s) unless path.is_a?(Pathname)
        path = path.expand_path
        
        raise PathNotFoundError, path unless path.exist?
        raise InvalidPath, path unless path.file?
        raise NotImageFileError, path unless include?(path.extname.downcase) =~ /^\.(#{VALID_TYPES.join('|')})$/
        
        @path = path
      end
      
      def data=(data)
        raise InvalidData unless data.respond_to?(:to_s)
        @data = data
      end
      
      # @param [String, #to_s] code
      # @return [String]
      def to_path(code)
        "#{code}_COV.png" # TODO: Get actual type... >_< oh god WHYYY
      end
      
      def inspect
        "#<#{self.class}:0x#{self.__id__.to_s(16)}>"
      end
    end
    
  end
end