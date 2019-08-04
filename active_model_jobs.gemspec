lib = File.expand_path('lib', __dir__)
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

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard"

  spec.add_dependency "activejob", ">= 5.0.0"
  spec.add_dependency "activemodel", ">= 5.0.0"
end
