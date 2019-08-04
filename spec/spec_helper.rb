$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

if ENV['CI']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'active_model/jobs'
require './spec/support/mocks'
