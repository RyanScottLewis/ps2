require 'ps2'

# TODO: Clean up with `error` gem

module PS2
  
  # The PS2 standard Error.
  class Error < StandardError
    
    # The error message.
    def to_s
      'Some unknown error has occurred! Please report this issue at https://github.com/c00lryguy/ps2/issues'
    end
    
  end
  
  # Raised when too many arguments are given.
  class TooManyArgumentsError < Error
    
    # @param arguments The arguments the developer tried to pass.
    def initialize(arguments)
      @arguments = arguments
    end
    
    # The error message.
    def to_s
      "Too many arguments given; '#@arguments.length' instead of 1."
    end
    
  end
  
  # Raised when the given options are invalid.
  class InvalidOptions < Error
    
    # @param options The options the developer tried to pass.
    def initialize(options)
      @options = options
    end
    
    # The error message.
    def to_s
      "Options #@options are invalid."
    end
    
  end
  
  # Raised when the given path is invalid.
  class InvalidPath < Error
    
    # @param [#to_s] path The path the developer tried to pass.
    def initialize(path)
      @path = path
    end
    
    # The error message.
    def to_s
      "Path #@path is invalid."
    end
    
  end
  
  # Raised when the given data is invalid.
  class InvalidData < Error
    
    # The error message.
    def to_s
      "The data given is invalid, it must respond to #to_s."
    end
    
  end
  
  # Raised when a path could not be read
  class ReadError < Error
    
    # @param [#to_s] path The path that was attempted to be read.
    def initialize(path)
      @path = path
    end
    
    # The error message.
    def to_s
      "The file '#@path' could not be read."
    end
    
  end
  
  # Raised when a given path is not a directory.
  class NotDirectoryError < Error
    
    # @param [#to_s] path The path that was not a directory
    def initialize(path)
      @path = path
    end
    
    # The error message.
    def to_s
      "The given path of '#@path' is not a directory."
    end
    
  end
  
  # Raised when a given path is not an image file.
  class NotImageFileError < Error
    
    # @param [#to_s] path The path that was not an image file.
    def initialize(path)
      @path = path
    end
    
    # The error message.
    def to_s
      "The given path of '#@path' is not a image file (#{Game::Artwork::VALID_TYPES.join(', ')})."
    end
    
  end
  
  # Raised when a given path is not an ISO file.
  class NotISOFileError < Error
    
    # @param [#to_s] path The path that was not an ISO file.
    def initialize(path)
      @path = path
    end
    
    # The error message.
    def to_s
      "The given path of '#@path' is not a ISO file."
    end
    
  end
  
  # Raised when a given path is not an ISO file.
  class InvalidISOFileError < Error
    
    # @param [#to_s] path The path that was not an ISO file.
    def initialize(path)
      @path = path
    end
    
    # The error message.
    def to_s
      "The given path of '#@path' is not a valid PS2 ISO file."
    end
    
  end
  
  # Raised when a given path is not a file.
  class NotFileError < Error
    
    # @param [#to_s] path The path that was not a file.
    def initialize(path)
      @path = path
    end
    
    # The error message.
    def to_s
      "The given path of '#@path' is not a file."
    end
    
  end
  
  # Raised when a given path does not exist on the filesystem.
  class PathNotFoundError < Error
    
    # @param [#to_s] path The path that was does not exist.
    def initialize(path)
      @path = path
    end
    
    # The error message.
    def to_s
      "The given path of '#@path' does not exist."
    end
    
  end
  
  # Raised when a 'code' option is invalid.
  class CodeParseError < ArgumentError
    
    # @param [#to_s] target the target that didnt match the code Regexp.
    def initialize(target='code')
      @target = target
    end
    
    # The error message.
    def to_s
      "#@target must match PS2::Game::CODE_REGEXP"
    end
  end
  
end
