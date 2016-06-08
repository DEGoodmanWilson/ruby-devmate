# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dev_mate/version'

Gem::Specification.new do |spec|
  spec.name          = "dev_mate"
  spec.version       = DevMate::VERSION
  spec.authors       = ["D.E. Goodman-Wilson"]
  spec.email         = ["degoodmanwilson@gmail.com"]

  spec.summary       = %q{An SDK for accessing the dev_mate API.}
  spec.description   = %q{Are you building an OS X app using dev_mate? Need to integrate the dev_mate API into your license server backend? Then this is the gem for you.}
  spec.homepage      = "https://github.com/DEGoodmanWilson/ruby-devmate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
