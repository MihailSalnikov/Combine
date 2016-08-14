require 'rubygems'
require 'bundler'
require 'bundler/setup'

Bundler.require
CONFIG = YAML.load_file("config/config.yml").inject({}) { |memo,(k,v)| memo[k.to_sym] = v; memo }

set :public_folder, File.dirname(__FILE__) + '/public'

require './combine'
require 'sinatra/activerecord'

require_relative 'models/user.rb'

set :port, 80

run Combine
