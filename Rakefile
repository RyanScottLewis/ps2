require 'pathname'

def require_task(path)
  begin
    require path
    
    yield
  rescue LoadError
    puts "Could not load '#{path}'.", 'Try to `rake gem:spec` and `bundle install` and try again.'
  end
end

spec = Gem::Specification.new do |s|
  s.name         = 'ps2'
  s.version      = Pathname.new(__FILE__).dirname.join('VERSION').read.strip
  s.author       = 'Ryan Scott Lewis'
  s.email        = 'ryan@rynet.us'
  s.homepage     = "http://github.com/c00lryguy/#{s.name}"
  s.summary      = 'Rename ISO files according to the OPL standard of `game_code.name.iso`, such as `SCUS_973.28.GT4.iso`'
  s.description  = 'Rename ISO files according to the OPL standard.'
  s.require_path = 'lib'
  s.files        = `git ls-files`.lines.to_a.collect { |s| s.strip }
  s.executables  = `git ls-files -- bin/*`.lines.to_a.collect { |s| File.basename(s.strip) }
  
  s.add_dependency 'bundler', '~> 1.2.2'
  s.add_dependency 'version', '~> 1.0.0'
  s.add_dependency 'slop', '~> 3.3.3'
  s.add_dependency 'rbcdio', '~> 0.05'
  # s.add_dependency 'glib-eventable', '~> 0.1.0'
  # s.add_dependency 'gtk2', '~> 1.1.5'
  s.add_development_dependency 'rake', '~> 0.9'
  s.add_development_dependency 'guard-rspec', '~> 2.1.1'
  s.add_development_dependency 'guard-yard', '~> 2.0.1'
  s.add_development_dependency 'redcarpet', '~> 2.2.2'
  s.add_development_dependency 'fakefs', '~> 0.4.1'
  s.add_development_dependency 'fuubar', '~> 1.1'
  s.add_development_dependency 'system', '~> 0.1.3'
  s.add_development_dependency 'nokogiri', '~> 1.5.5'
  s.add_development_dependency 'ruby-progressbar', '~> 1'
  s.add_development_dependency 'thread', '~> 0.0.1'
  # s.add_development_dependency 'at', '~> 0.1.2'
end

require_task 'rake/version_task' do
  Rake::VersionTask.new do |t|
    t.with_git_tag = true
    t.with_gemspec = spec
  end
end

require_task 'rspec/core/rake_task' do
  RSpec::Core::RakeTask.new
end

namespace :gem do
  task :spec do
    Pathname.new("#{spec.name}.gemspec").open('w') { |f| f.write(spec.to_ruby) }
  end
end

require 'rubygems/package_task'
Gem::PackageTask.new(spec) do |t|
  t.need_zip = false
  t.need_tar = false
end

task default: 'gem:spec'
