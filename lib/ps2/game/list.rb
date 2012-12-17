require 'ps2/game'
require 'pathname'
require 'yaml'

module PS2
  class Game
    
    # An Array of Game instances
    class List < Array
      
      class << self
        
        # The path of the games.
        # 
        # @return [Pathname]
        def path
          @path ||= Pathname.new(__FILE__).join('..', '..', '..', '..', 'data', 'games.yml').expand_path
        end
        
        # Load the game data.
        # 
        # @return [PS2::Game::List]
        def load
          games = YAML.load_file(path) if path.exist?
          
          new(games)
        end
        
      end
      
      def initialize(list=nil)
        super()
        replace(list) unless list.nil?
      end
      
      # @return [PS2::Game]
      def find_by_code(code)
        code = code.lines.to_a.first.strip
        raise CodeParseError unless code =~ CODE_REGEXP
        
        result = find { |game| game.codes.include?(code) }
        result ||= Game.new
        result.code = code
        
        result
      end
      
    end
    
  end
end