# frozen_string_literal: true

require_relative "lib/version"

Gem::Specification.new do |s|
  s.name = "green_shed_press"
  s.version = GSP::VERSION
  s.summary = "Static site generator"
  s.description = "Basic static site generator, written in Ruby, with an emphasis on Photo features."
  s.authors = ["Jeff McFadden"]
  s.email = "jeff.mcfadden@companycam.com"
  s.license = "MIT"
  s.files = Dir.glob("lib/**/*")
  s.homepage = "https://github.com/jeffmcfadden/green_shed_press"

  s.add_dependency "redcarpet"

  s.add_development_dependency "debug"
  s.add_development_dependency "tldr"
end
