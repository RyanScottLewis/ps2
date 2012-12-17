require 'thread'
require 'open-uri'
require 'pathname'
require 'yaml'
require 'pp'

__LIB__ ||= Pathname.new(__FILE__).join('..', '..', 'lib')
$:.unshift(__LIB__.to_s) unless $:.include?(__LIB__.to_s)

require 'ps2'
require 'ruby-progressbar'
require 'system/cpu'
require 'nokogiri'
require 'thread/pool'

module PS2
  
  module OPL
    
    class << self
      
      def uris
        uris = ('a'..'z').collect { |letter| "http://opl.sksapps.com/index.php?opl=cover#{letter}.html" }
        uris.unshift('http://opl.sksapps.com/index.php?opl=cover.html')
      end
      
    end
    
    class Document
      
      class << self
        
        # Load a from a URI.
        def load(uri)
          new( open(uri) )
        end
        
        # Load and parse from a URI.
        def parse(uri)
          load(uri).parse
        end
        
      end
      
      # The HTML String.
      attr_reader :html
      
      # The parsed HTML Nokogiri::XML::NodeSet.
      attr_reader :parsed_html
      
      # A list of games on the document.
      attr_reader :games
      
      def initialize(html)
        @html = html
      end
      
      def parse
        @parsed_html = Nokogiri::HTML(@html)
        @games = []
        @parsed_html.xpath('//*[@id="level2nav"]/ul/li').each do |li|
          @games << PS2::Game.new(
            name: li.xpath('span[1]/b').first.content,
            codes: li.xpath('span[2]/span//input').collect do |node|
              Pathname.new( node[:value] ).basename.to_s.gsub(/_COV\.[a-z]+/, '')
            end
          )
        end
        
        self
      end
      
    end
    
    class Harvester
      
      def initialize
        @thread_pool = Thread::Pool.new(System::CPU.count * 4)
        @progress_bar = ProgressBar.create(format: '%a |%b>>%i| %p%% %t', total: OPL.uris.length)
        @games_queue = Queue.new
        
        at_exit { @thread_pool.shutdown }
        trap('TERM') { @thread_pool.shutdown }
      end
      
      def process
        OPL.uris.each do |uri|
          # @thread_pool.process do
            document = Document.parse(uri)
            @games_queue << document.games
            @progress_bar.increment
          # end
        end
        
        # @thread_pool.shutdown
        # @progress_bar.finish
        
        result = []
        
        loop do
          games = @games_queue.pop
          
          result += games
          
          break if @games_queue.empty?
        end
        
        Pathname.new(__FILE__).join('..', '..', 'data', 'codes.yml').expand_path.open('w+') do |file|
          file.puts result.to_yaml
        end
        
        result
      end
      
    end
    
  end
end

harvester = PS2::OPL::Harvester.new
puts "Harvesting PS2 game codes..."
harvester.process
puts "Done!"