require 'rubygems'
require 'bundler'
require 'bundler/setup'

Bundler.require
CONFIG = YAML.load_file("config/config.yml").inject({}) { |memo,(k,v)| memo[k.to_sym] = v; memo }

require './combine'
require 'sinatra/activerecord'
<<<<<<< HEAD
require_relative '/models/user.rb'
require_relative '/config/config.rb'
=======
require_relative 'models/user.rb'
>>>>>>> 4e5c1c8aab506382856b494b55d721a27c54e447

set :port, 80

run Combine
