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
require 'thread/pool'


# use as array.chunk
class Array
  def chunk(pieces=2)
    len = self.length;
    mid = (len/pieces)
    chunks = []
    start = 0
    1.upto(pieces) do |i|
      last = start+mid
      last = last-1 unless len%pieces >= i
      chunks << self[start..last] || []
      start = last+1
    end
    chunks
  end
end

worker_count = System::CPU.count * 4
thread_pool = Thread::Pool.new(worker_count)

at_exit { thread_pool.shutdown }
trap('TERM') { thread_pool.shutdown }

puts "Harvesting artwork for #{PS2::Game.list.count} games...", ''
progress_bar = ProgressBar.create(format: '%a - %e |%b>>%i| %p%% %t', total: PS2::Game.list.length)

def sleep_humanly
  sleep rand
end

PS2::Game.list.chunk(worker_count).each do |chunk|
  thread_pool.process do
    sleep_humanly
    chunk.each do |game|
      retry_count = 0
      begin
        sleep_humanly
        url = "http://opl.sksapps.com/art/#{game.code}_COV.jpg"
        # url = "http://openps2loader.info/8/art/#{game.code}_COV.jpg"
        # if game.artwork.nil? || game.artwork.data.nil?
          data = open(url).read rescue nil
          data = nil if data =~ /DOCTYPE/
          # game.artwork = PS2::Game::Artwork.new
          # game.artwork.data = data unless data.nil?
          unless data.nil?
            path = Pathname.new(__FILE__).join('..', '..', 'data', 'artwork', "#{game.code}.jpg").expand_path
            path.open('w+') { |file| file.print(data) }
          end
        # end
        
        rows, columns = IO.console.winsize
        
        msg = "Got #{game.safe_name}"
        puts msg + (' ' * (columns-msg.length)) unless data.nil?
        
        msg = "Miss #{game.safe_name}"
        puts msg + (' ' * (columns-msg.length)) if data.nil?
        
        progress_bar.increment
        
        game
      rescue
        retry unless retry_count > 5
      end
    end
  end
end

thread_pool.shutdown

# Pathname.new(__FILE__).join('..', '..', 'data', 'games.new.yml').expand_path.open('w+') do |file|
#   file.puts PS2::Game.list.to_yaml
# end

puts "Done!"

# __END__

# PS2::ISO.scan("/Volumes/RyNet/Games/PS2/DVD/").collect(&:game).each do |game|
#   if !game.nil? && !game.artwork.nil? && !game.artwork.data.nil?
#     filename = game.artwork.to_path(game.code)
#     Pathname.new('/Volumes/RyNet/Games/PS2/ART/').join(filename).open('w+') { |f| f.print(game.artwork.data) }
#   end
# end; nil
  
