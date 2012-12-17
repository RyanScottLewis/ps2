require 'ps2'

module PS2
  
  # The base class for the CLI and GUIs.
  class Application
    class << self
      
      # Create a new instance of the application and call #run on it.
      def run
        new.run
      end
      
    end
    
    # @abstract Subclass and override {#run} to implement a custom Application class.
    def run
      raise NotImplementedError
    end
  end
  
end