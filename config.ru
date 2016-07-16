require 'rubygems'
require 'bundler'

Bundler.require

require './combine'
require "sinatra/activerecord"
require_relative 'models/user.rb'
require_relative 'config/config.rb'


set :database, {adapter: "sqlite3", database: "db/combine.sqlite3"}

run Combine


