require 'ps2/game'
require 'pathname'
require 'iso9660'

module PS2
  
  # An ISO file of a PS2 backup.
  class ISO
    
    class << self
      
      # Scan the given directory for ISO files and rename them using PS2.
      #
      # @param [String, #to_s] path The directory to scan.
      # @param [Hash, #to_hash, #to_h] options The options.
      # @option options [String, #to_s] :name Use this name instead of figuring it out from the ISO file.
      # @option options [String, #to_s] :code Use this code instead of figuring it out from the ISO file.
      # @yield [code, name] Manipulate the resulting filename with this block. It must return an object that responds to #to_s. This is run on each file in the scan results.
      # @yieldparam [String] code The code read from the ISO. This will be the value of the :code option, if given.
      # @yieldparam [String] name The name read from the ISO. This will be the value of the :name option, if given.
      # @yieldparam [Integer] index The index of the current ISO path in the enumeration.
      # @yieldreturn [String, #to_s] The filename to rename the ISO as.
      # @raise [PS2::NotDirectoryError] This error will be raised when the given path is not a valid directory.
      # @raise [PS2::InvalidPath] This error will be raised when the given path is invalid.
      # @raise [PS2::InvalidOptions] This error will be raised when the given options are invalid.
      # @return [Hash] A Hash where the keys are the old Pathnames and the value is either the new Pathname or the error that was thrown when trying to rename it.
      # @example Scan the parent working directory (PWD) for ISO files.
      #   PS2.scan
      # @example Scan the given directory for ISO files.
      #   PS2.scan('/some/other/path')
      # @example Scan the given directory for ISO files and rename each according to the block.
      #   PS2.scan('/some/other/path') do |code, name, index|
      #     "#{code}.#{name}.iso"
      #   end
      # @example Scan the given directory for ISO files and rename each according to the block while passing options.
      #   PS2.scan('/some/other/path', name: 'Game') do |code, name, index|
      #     "#{code}.#{name} #{index+1}.iso"
      #   end
      def scan(path, options={}, &blk)
        raise InvalidPath, path unless path.is_a?(Pathname) || path.respond_to?(:to_s)
        path = Pathname.new(path.to_s) unless path.is_a?(Pathname)
        
        Pathname.glob( path.join('*.[Ii][Ss][Oo]') ).each_with_object([]) do |path, memo|
          memo << begin
            new(path, &blk)
          rescue => e
            e
          end
        end
      end
      
      # # Rename the given filename to the OPL standard of `game_code.name.iso`.
      # #
      # # @param [String, #to_s] path The filename to rename.
      # # @param [Hash, #to_hash, #to_h] options The options.
      # # @option options [String, #to_s] :name Use this name instead of figuring it out from the ISO file.
      # # @option options [String, #to_s] :code Use this code instead of figuring it out from the ISO file.
      # # @yield [code, name] Manipulate the resulting filename with this block. It must return an object that responds to #to_s.
      # # @yieldparam [String] code The code read from the ISO. This will be the value of the :code option, if given.
      # # @yieldparam [String] name The name read from the ISO. This will be the value of the :name option, if given.
      # # @yieldreturn [String, #to_s] The filename to rename the ISO as.
      # # @raise [PS2::NotISOFileError] This error will be raised when the given path is not an ISO file.
      # # @raise [PS2::ReadError] This error will be raised when the given path could not be read.
      # # @raise [PS2::InvalidPath] This error will be raised when the given path is invalid.
      # # @raise [PS2::InvalidOptions] This error will be raised when the given options are invalid.
      # # @return [Pathname] The path of the renamed file.
      # # @example Auto parse name and code
      # #   iso.rename
      # # @example Set name manually, will rename file to "SLUS_012.34.My Game 2.iso".
      # #   iso.rename(name: 'My Game 2')
      # # @example Set name and code manually, will rename file to "SLUS_999.99.My Game 2.iso".
      # #   iso.rename(name: 'My Game 2', code: 'slus_999.99')
      # # @example Rename according to the block, will rename file to "SLUS_012.34.mypoorlynamedgamethesequel.iso".
      # #   iso.rename do |code, name|
      # #     name = name.gsub(/\s|-/, '').downcase
      # #     
      # #     "#{code}.#{name}.iso"
      # #   end
      # # @example Rename according to the block while passing options, will rename file to "OMG_1234.FUNNY GAME.iso".
      # #   iso.rename(code: 'omg_1234', name: 'Funny Game') do |code, name|
      # #     "#{code}.#{name}.iso"
      # #   end
      # def rename(options={}, &blk)
      #   # raise InvalidPath.new(path) unless path.respond_to?(:to_s)
      #   raise InvalidOptions.new(options) unless options.nil? || [:to_hash, :to_h].any? { |method| options.respond_to?(method) }
      #   
      #   # path = Pathname.new(path.to_s) unless path.is_a?(Pathname)
      #   # raise PathNotFoundError.new(path) unless path.exist?
      #   # raise NotFileError.new(path) unless path.file?
      #   # raise NotISOFileError.new(path) unless path.extname.downcase == '.iso'
      #   options = options.to_hash rescue options.to_h unless options.is_a?(Hash)
      #   
      #   options[:code] = game.code if options[:code].nil?
      #   options[:name] = game.safe_name if options[:name].nil?
      #   
      #   new_path = yield(*options.values_at(:code, :name)) if block_given?
      #   
      #   new_path = if new_path.nil?
      #     @path.dirname.join("#{options[:code]}.#{options[:name]}.iso")
      #   else
      #     @path.dirname.join(new_path)
      #   end
      #   
      #   @path.rename( new_path.to_s.encode('us-ascii') )
      #   @path = new_path
      #   
      #   @path
      # end
      
    end
    
    # @param [String, Pathname, #to_s] path The path of the ISO file on the filesystem.
    # @raise [PS2::PathNotFoundError] This error will be raised when the given path is not found.
    # @raise [PS2::InvalidPath] This error will be raised when the given path is invalid.
    # @raise [PS2::NotISOFileError] This error will be raised when the given path is not an ISO file.
    def initialize(path)
      raise InvalidPath, path unless path.respond_to?(:to_s)
      path = Pathname.new(path.to_s) unless path.is_a?(Pathname)
      @path = path.expand_path
      
      raise PathNotFoundError, @path unless @path.exist?
      raise InvalidPath, @path unless @path.file?
      raise NotISOFileError, @path unless @path.extname.downcase == '.iso'
      
      parse_code
    end
    
    # Get the game code of the PS2 Game ISO.
    # 
    # @return [String]
    attr_reader :code
    
    # Get the path of the PS2 Game ISO.
    # 
    # @return [String]
    attr_reader :path
    
    # Return the PS2::Game instance associated with this ISO instance.
    # 
    # @return [PS2::Game]
    def game
      if @game.nil?
        @game = Game.list.find_by_code(@code)
        @game.name ||= @path.basename.to_s.gsub(/\.[Ii][Ss][Oo]$/, '').gsub(/^[A-Z]{4}_\d{3}\.\d{2}\./, '')
        @game
      end
    end
    
    # Rename the given filename to the OPL standard of `game_code.name.iso`.
    #
    # @param [String, #to_s] path The filename to rename.
    # @param [Hash, #to_hash, #to_h] options The options.
    # @option options [String, #to_s] :name Use this name instead of figuring it out from the ISO file.
    # @option options [String, #to_s] :code Use this code instead of figuring it out from the ISO file.
    # @yield [code, name] Manipulate the resulting filename with this block. It must return an object that responds to #to_s.
    # @yieldparam [String] code The code read from the ISO. This will be the value of the :code option, if given.
    # @yieldparam [String] name The name read from the ISO. This will be the value of the :name option, if given.
    # @yieldreturn [String, #to_s] The filename to rename the ISO as.
    # @raise [PS2::NotISOFileError] This error will be raised when the given path is not an ISO file.
    # @raise [PS2::ReadError] This error will be raised when the given path could not be read.
    # @raise [PS2::InvalidPath] This error will be raised when the given path is invalid.
    # @raise [PS2::InvalidOptions] This error will be raised when the given options are invalid.
    # @return [Pathname] The path of the renamed file.
    # @example Auto parse name and code
    #   iso.rename
    # @example Set name manually, will rename file to "SLUS_012.34.My Game 2.iso".
    #   iso.rename(name: 'My Game 2')
    # @example Set name and code manually, will rename file to "SLUS_999.99.My Game 2.iso".
    #   iso.rename(name: 'My Game 2', code: 'slus_999.99')
    # @example Rename according to the block, will rename file to "SLUS_012.34.mypoorlynamedgamethesequel.iso".
    #   iso.rename do |code, name|
    #     name = name.gsub(/\s|-/, '').downcase
    #     
    #     "#{code}.#{name}.iso"
    #   end
    # @example Rename according to the block while passing options, will rename file to "OMG_1234.FUNNY GAME.iso".
    #   iso.rename(code: 'omg_1234', name: 'Funny Game') do |code, name|
    #     "#{code}.#{name}.iso"
    #   end
    def rename(options={}, &blk)
      raise InvalidOptions.new(options) unless options.nil? || [:to_hash, :to_h].any? { |method| options.respond_to?(method) }
      options = options.to_hash rescue options.to_h unless options.is_a?(Hash)
      
      game.code = options[:code] unless options[:code].nil?
      game.name = options[:name] unless options[:name].nil?
        
      new_path = yield(*options.values_at(:code, :name)) if block_given?
        
      new_path = @path.dirname.join(game.to_path) if new_path.nil?
      new_path = @path.dirname.join(new_path.to_s) unless new_path.nil?
      
      @path.rename(new_path) unless new_path == @path
      @path = new_path unless new_path == @path
      
      @path
    end
    
    protected
    
    def parse_code
      iso = ISO9660::IFS.new(@path.to_s)
      raise ReadError, @path unless iso.open?
      
      entries = iso.readdir('/').collect { |entry| ISO9660.name_translate( entry['filename'] ).upcase }
      @code = entries.select { |entry| entry =~ Game::CODE_REGEXP }.first
      
      raise InvalidISOFileError, @path if @code.nil?
      
      iso.close
    end
    
  end
  
end
