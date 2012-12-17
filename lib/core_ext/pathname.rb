require 'pathname'

# Extensions to Pathname.
class Pathname
  
  # Convert this Pathname to a more human readable format.
  # 
  # @return [String] The file's basename without the extension in a human readable format.
  # @example
  #   Pathname.new('/some/path/slus_999.99.My awesome_game-the_sequel.ISO').to_opl_name # => "My Awesome Game - The Sequel"
  def to_opl_name
    basename('.*').to_s.to_opl_name
  end
  
end
