$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
require 'active_model/jobs'
require './spec/support/mocks'

SimpleCov.start
