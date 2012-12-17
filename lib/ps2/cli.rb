require 'ps2/application'

module PS2
  
  # The Graphical User Interface (GUI)
  class CLI < Application
    
    def initialize
      parse_options
      parse_arguments
    end
    
    # Print the current version of PS2 and exit.
    def print_version
      puts VERSION
      
      exit
    end
    
    # Scan the current or given DIRECTORY for ISO files and run ps2 on each, skipping failures.
    # This ignores any other options.
    def scan
      PS2.scan(@options.scan, @options)
    end
    
    # Rename the given file
    def rename_given_file
      PS2.rename(@filename, @options)
    end
    
    # Lasily load the Graphical User Interface (GUI) and run it.
    def run_gui
      require 'ps2/gui'
      
      GUI.run
    end
    
    # Start the CLI run loop, print error and exit on exceptions.
    def run
      begin
        raise TooManyArgumentsError.new(@arguments) if @arguments.length > 1
        
        print_version if @options.version?
        scan if @options.scan?
        rename_given_file unless @arguments.empty?
        run_gui if @arguments.empty?
        
        raise Error
      rescue => e
        puts e.to_s
        
        exit(1)
      end
    end
    
    protected
      
    # Parse the command line options using Slop.parse.
    def parse_options
      @options = Slop.parse do
        banner "ps2 [filename] [options]\n"
          
        on :name, 'Do not parse the name of the game from the ISO and use the given NAME instead.'
        on :code, 'Do not parse the code of the game from the ISO and use the given CODE instead.'
        on :scan, 'Scan the current or given DIRECTORY for ISO files and run ps2 on each, skipping failures. This ignores any other options.'
        on :version, 'Print the current version of ps2. This ignores any other options.'
      end
      
      @options.scan = Pathname.pwd if @options.scan == true
    end
      
    # Parse the command line arguments.
    def parse_arguments
      @arguments = ARGV.collect { |arg| arg.strip }
      @filename = Pathname.new(@arguments.first)
    end
    
  end
  
end
