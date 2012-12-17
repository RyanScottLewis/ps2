# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ps2"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Scott Lewis"]
  s.date = "2012-11-24"
  s.description = "Rename ISO files according to the OPL standard."
  s.email = "ryan@rynet.us"
  s.homepage = "http://github.com/c00lryguy/ps2"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Rename ISO files according to the OPL standard of `game_code.name.iso`, such as `SCUS_973.28.GT4.iso`"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bundler>, ["~> 1.2.2"])
      s.add_runtime_dependency(%q<version>, ["~> 1.0.0"])
      s.add_runtime_dependency(%q<slop>, ["~> 3.3.3"])
      s.add_runtime_dependency(%q<rbcdio>, ["~> 0.05"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 2.1.1"])
      s.add_development_dependency(%q<guard-yard>, ["~> 2.0.1"])
      s.add_development_dependency(%q<redcarpet>, ["~> 2.2.2"])
      s.add_development_dependency(%q<fakefs>, ["~> 0.4.1"])
      s.add_development_dependency(%q<fuubar>, ["~> 1.1"])
      s.add_development_dependency(%q<system>, ["~> 0.1.3"])
      s.add_development_dependency(%q<nokogiri>, ["~> 1.5.5"])
      s.add_development_dependency(%q<ruby-progressbar>, ["~> 1"])
      s.add_development_dependency(%q<thread>, ["~> 0.0.1"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.2.2"])
      s.add_dependency(%q<version>, ["~> 1.0.0"])
      s.add_dependency(%q<slop>, ["~> 3.3.3"])
      s.add_dependency(%q<rbcdio>, ["~> 0.05"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<guard-rspec>, ["~> 2.1.1"])
      s.add_dependency(%q<guard-yard>, ["~> 2.0.1"])
      s.add_dependency(%q<redcarpet>, ["~> 2.2.2"])
      s.add_dependency(%q<fakefs>, ["~> 0.4.1"])
      s.add_dependency(%q<fuubar>, ["~> 1.1"])
      s.add_dependency(%q<system>, ["~> 0.1.3"])
      s.add_dependency(%q<nokogiri>, ["~> 1.5.5"])
      s.add_dependency(%q<ruby-progressbar>, ["~> 1"])
      s.add_dependency(%q<thread>, ["~> 0.0.1"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.2.2"])
    s.add_dependency(%q<version>, ["~> 1.0.0"])
    s.add_dependency(%q<slop>, ["~> 3.3.3"])
    s.add_dependency(%q<rbcdio>, ["~> 0.05"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<guard-rspec>, ["~> 2.1.1"])
    s.add_dependency(%q<guard-yard>, ["~> 2.0.1"])
    s.add_dependency(%q<redcarpet>, ["~> 2.2.2"])
    s.add_dependency(%q<fakefs>, ["~> 0.4.1"])
    s.add_dependency(%q<fuubar>, ["~> 1.1"])
    s.add_dependency(%q<system>, ["~> 0.1.3"])
    s.add_dependency(%q<nokogiri>, ["~> 1.5.5"])
    s.add_dependency(%q<ruby-progressbar>, ["~> 1"])
    s.add_dependency(%q<thread>, ["~> 0.0.1"])
  end
end
