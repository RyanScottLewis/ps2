require 'pathname'

__LIB__ ||= Pathname.new(__FILE__).join('..', '..', 'lib').expand_path
$:.unshift(__LIB__.to_s) unless $:.include?(__LIB__.to_s)

require 'ps2'
require 'bundler/setup'

Bundler.require(:development)
FakeFS.deactivate!

require 'fakefs/spec_helpers'

module SpecHelpers
  
  def create_file(path, &blk)
    File.open(path, 'w+') { |f| f.print('') }
    yield(path) if block_given?
    delete_file(path) if block_given?
    
    path
  end
  
  def delete_file(path)
    File.delete(path)
    
    path
  end
  
  def create_dir(path, &blk)
    FileUtils.mkdir(path)
    yield(path) if block_given?
    delete_dir(path) if block_given?
    
    path
  end
  
  def delete_dir(path)
    Dir.delete(path)
    
    path
  end
  
end

RSpec.configure do |c|
  c.include FakeFS::SpecHelpers
  c.include SpecHelpers
end