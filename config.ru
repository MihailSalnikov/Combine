require 'rubygems'
require 'bundler'
require 'bundler/setup'

Bundler.require
CONFIG = YAML.load_file("config/config.yml").inject({}) { |memo,(k,v)| memo[k.to_sym] = v; memo }

require './combine'
require 'sinatra/activerecord'
require_relative 'models/user.rb'
require_relative 'config/config.rb'

set :port, 80

run Combine
