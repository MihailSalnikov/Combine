require 'sinatra'
require 'sinatra/activerecord'

class Combine < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	get '/' do
		redirect '/'+Time.now.to_s.gsub!(/[^0-9]/, '') if request.path.to_i == 0
	end

	post '/board' do
		User.create(time: params[:current_time], ip: request.ip.to_s)
	end

	get '/board' do
		@users = User.order('time DESC')
		erb :board
	end

	get '/:current_time' do
		@current_time = request.path.to_s.gsub!(/[^0-9]/, '').to_i
		erb :index
	end

end