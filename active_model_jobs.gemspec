# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_model/jobs/version'

Gem::Specification.new do |spec|
  spec.name          = "active_model_jobs"
  spec.version       = ActiveModel::Jobs::VERSION
  spec.authors       = ["Tom Scott"]
  spec.email         = ["tscott@weblinc.com"]

  spec.summary       = "Enqueue ActiveJobs in your ActiveModel."
  spec.description   = "#{spec.summary} Helps you call background jobs."
  spec.homepage      = "http://github.com/tubbo/active_model-jobs"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "rubocop", "~> 0"
  spec.add_development_dependency "yard", "~> 0"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0"

  spec.add_dependency "activemodel", "~> 5.0.0.pre"
  spec.add_dependency "activejob", "~> 5.0.0.pre"
end
