# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'td/core/version'

Gem::Specification.new do |spec|
  spec.name          = "td-core"
  spec.version       = TD::Core::VERSION
  spec.authors       = ["David Castillo", "René Dávila", "Santiago Vanegas"]
  spec.email         = [
    "juandavid.castillo@talosdigital.com",
    "rene.davila@talosdigital.com",
    "santiago.vanegas@talosdigital.com"
  ]

  spec.summary       = 'Common modules for all the TD gems.'
  spec.homepage      = "https://github.com/talosdigital/TDCoreGem"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '4.2.3'
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
