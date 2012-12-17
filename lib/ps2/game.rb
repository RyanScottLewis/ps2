require 'ps2/game/artwork'
require 'ps2/game/list'
require 'pathname'
require 'yaml'

module PS2
  
  # A PS2 Game.
  class Game
    # The Regexp that all game codes must conform to.
    CODE_REGEXP = /[A-Z0-9]{4}_\d{3}\.\d{2}/
    
    class << self
      
      # A cache containing a list of known PS2 games.
      def list
        @list ||= List.load
      end
      
    end
    
    # @param [Hash, #to_hash, #to_h] options
    # @option options [String, #to_s] :name The name of the Game instance.
    # @option options [String, #to_s] :code The code of the Game instance.
    # @option options [<String, #to_s>] :codes The codes of the Game instance.
    def initialize(options={})
      raise TypeError unless options.respond_to?(:to_hash) || options.respond_to?(:to_h)
      options = options.to_hash rescue options.to_h
      
      self.name = options[:name] if options.has_key?(:name)
      self.code = options[:code] if options.has_key?(:code)
      self.codes = options[:codes] if options.has_key?(:codes)
    end
    
    # Get the Artwork instance of this Game instance.
    # 
    # @return [PS2::Game::Artwork, nil]
    attr_reader :artwork
    
    # Set the Artwork instance of this Game instance.
    # 
    # @param [Artwork] artwork
    # @return [Artwork]
    def artwork=(artwork)
      raise TypeError, 'artwork must be an instance of PS2::Game::Artwork' unless artwork.instance_of?(PS2::Game::Artwork)
      @artwork = artwork
    end
    
    # Get the name of this Game instance.
    # 
    # @return [String]
    attr_reader :name
    
    # Get the name of this Game instance that is safe for the filesystem.
    # 
    # @return [String]
    def safe_name
      name.to_s.gsub(/[^a-zA-Z0-9 _\-:\.]/, '').gsub(/:/, ' - ').gsub(/ +/, ' ')
    end
    
    # Set the name of this Game instance.
    # 
    # @param [String, #to_s] name
    # @return [String]
    def name=(name)
      raise TypeError, 'name must respond to :to_s' unless !name.nil? && name.respond_to?(:to_s)
      @name = name.to_s
    end
    
    # Get game code of this Game instance.
    # 
    # @return [String]
    def code
      @code ||= @codes.first
    end
    
    # Set the game code of this Game instance.
    # 
    # @param [String, #to_s] code
    # @return [String]
    def code=(code)
      raise TypeError, 'code must respond to :to_s' unless !code.nil? && code.respond_to?(:to_s)
      code = code.to_s
      raise CodeParseError unless code =~ CODE_REGEXP
      codes << code unless codes .include?(code)
      
      @code = code
    end
    
    # Get the game codes associated with this game. Note that a game may have multiple
    # game codes and a single game code. Basically, all instances with the same name will
    # have the same #codes list, not may not have the same #code.
    # 
    # @return [<String>]
    def codes
      @codes ||= []
    end
    
    # Set the game codes associated with this Game instance.
    # 
    # @param [<String, #to_s>] codes
    # @return [<String>]
    def codes=(codes)
      raise TypeError, 'codes must respond to :to_a' unless !codes.nil? && codes.respond_to?(:to_a)
      raise TypeError, 'codes children must all respond to :to_s' unless codes.all? { |code| !code.nil? && code.respond_to?(:to_s) }
      codes.collect! { |code| code.to_s }
      raise CodeParseError, 'codes children' unless codes.all? { |code| code =~ CODE_REGEXP }
      @code ||= codes.first
      
      @codes = codes
    end
    
    def to_path
      "#{code}.#{safe_name}.iso"
    end
    
    # @return [Hash]
    def to_h
      { name: @name, code: @code, codes: @codes }
    end
    
  end
  
end