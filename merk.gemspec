# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'merk/version'

Gem::Specification.new do |spec|
  spec.name          = "merk"
  spec.version       = Merk::VERSION
  spec.authors       = ["irving"]
  spec.email         = ["irvingthemagnificent@yahoo.com"]
  spec.summary       = %q{Tools for developing a merkle tree}
  spec.description   = %q{Tools for comparing two sets of data using a merkle tree}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
