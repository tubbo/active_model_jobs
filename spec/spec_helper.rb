$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'active_model/jobs'
require './spec/support/mocks'

if ENV['CI']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end
