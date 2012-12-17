require 'ps2/application'
require 'gtk2'
require 'glib/eventable'

module PS2
  
  # The Graphical User Interface (GUI)
  class GUI < Application
    
    # The main window.
    class Window < Gtk::Window
      
    end
      
    # Start the GUI run loop.
    def run
      Window.new
      Gtk.main
    end
    
  end
end
