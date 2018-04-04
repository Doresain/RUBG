
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pubg_rb/version"

Gem::Specification.new do |spec|
  spec.name          = "pubg_rb"
  spec.version       = PubgRb::VERSION
  spec.authors       = ["Dor"]
  spec.email         = ["dor.edras@gmail.com"]

  spec.summary       = %q{Unofficial PUBG API wrapper gem for Ruby.}
  spec.description   = %q{Unofficial PUBG API wrapper gem for Ruby.}
  spec.homepage      = "https://github.com/dor-edras/pubg_rb"
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
  spec.add_dependency "json"
end
