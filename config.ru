require 'rubygems'
require 'bundler'
require 'bundler/setup'

Bundler.require

require './combine'
require "sinatra/activerecord"
require_relative 'models/user.rb'
require_relative 'config/config.rb'

set :port, 80

run Combine


