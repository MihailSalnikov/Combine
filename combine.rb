require 'sinatra'
require 'sinatra/activerecord'
require_relative 'lib/http_proxy_checker'
require 'geoip'

class Combine < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get '/' do
    redirect '/'+Time.now.to_s.gsub!(/[^0-9]/, '') if request.path.to_i == 0
  end

  post '/board' do

    test_uri = URI::HTTP.new("http",nil,CONFIG[:domain],80,nil,"/",nil,nil,nil)
    is_proxy = HttpProxyChecker.new(test_uri, request.ip).first == true
    user = User.new(time: params[:current_time], ip: request.ip.to_s, proxy: is_proxy)
    if user.proxy
      # check real ip
    else
      user.location = GeoIP.new('GeoLiteCity.dat').city(user.ip).to_s
    end
    user.save
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
