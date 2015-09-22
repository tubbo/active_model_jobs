require "bundler/setup"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yard"
require "active_model/jobs"

RSpec::Core::RakeTask.new :spec

RuboCop::RakeTask.new :lint

YARD::Rake::YardocTask.new :doc

desc "Run all RuboCop lint checks and RSpec code examples"
task test: %w(lint spec)

desc "Create tag and push tags to GitHub"
task :release do
  sh "git tag v#{ActiveModel::Jobs::VERSION}"
  sh "git push --tags"
end

# CI task.
task default: :test
