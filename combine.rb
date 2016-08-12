require 'net/http'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'lib/http_proxy_checker'
require_relative 'lib/get_vk_id'
require 'geoip'


class Combine < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  get '/' do
    redirect '/'+Time.now.to_s.gsub!(/[^0-9]/, '') if request.path.to_i == 0
  end

  post '/vk_id' do
    user = User.find_by(time: params[:current_time])
    user.vk_id = params[:vk_id].to_i
    user.save
  end

  get '/board' do
    @users = User.all.order('time DESC')
    erb :board
  end

  get '/dummy' do
    status 200
    body Digest::SHA256.hexdigest(CONFIG[:domain])
  end

  get '/:current_time' do
    @current_time = request.path.to_s.gsub!(/[^0-9]/, '').to_i
    
    if ((User.find_by time: @current_time) == nil || (User.find_by time: @current_time).ip != request.ip.to_s)
      user = User.new(time: @current_time, ip: request.ip.to_s)
      test_uri = URI::HTTP.new("http",nil,CONFIG[:domain],80,nil,"/dummy",nil,nil,nil)
      is_proxy = HttpProxyChecker.new(test_uri, request.ip).check.first == true
      user.proxy = is_proxy
      if user.proxy
      # check real ip
      else
        user.location = GeoIP.new('GeoLiteCity.dat').city(user.ip).to_s
      end
      user.save
    end

    erb :index
  end
end
