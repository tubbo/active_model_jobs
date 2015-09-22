require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yard"

RSpec::Core::RakeTask.new :spec

RuboCop::RakeTask.new :lint

YARD::Rake::YardocTask.new :doc

desc "Run all RuboCop lint checks and RSpec code examples"
task test: %w(lint spec)

# CI task.
task default: :test
