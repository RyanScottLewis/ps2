# Extensions to String.
class String
  
  # Convert this String to a more human readable format.
  # 
  # @return [String] This String to a more human readable format.
  # @example
  #   'My     awesome_game-the_.!sequel'.to_opl_name # => "My Awesome Game - The Sequel"
  def to_opl_name
    gsub(/[^a-zA-Z0-9\.\-\+]/, ' ').split.collect(&:capitalize).join
  end
  
end
