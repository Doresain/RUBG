
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubg/version"

Gem::Specification.new do |spec|
  spec.name          = "rubg"
  spec.version       = RUBG::VERSION
  spec.authors       = ["Dor"]
  spec.email         = ["dor.edras@gmail.com"]

  spec.summary       = %q{RUBG is a Ruby wrapper for the official PUBG API.}
  spec.description   = %q{RUBG is a Ruby wrapper for the official PUBG API.}
  spec.homepage      = "https://github.com/dor-edras/rubg"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "httparty", "~> 0.16.2"
  spec.add_dependency "json", "~> 2.1.0"
  spec.add_dependency "zlib", "~> 1.0.0"
end
