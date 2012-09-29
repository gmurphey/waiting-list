require 'sinatra/base'
require 'sinatra/config_file'
require 'data_mapper'
require 'rack/flash'

require './models/email'

class WaitingList < Sinatra::Base
  register Sinatra::ConfigFile

  enable :sessions
  use Rack::Flash

  config_file './config.yml'

  DataMapper.setup(:default, "postgres://#{settings.database[:name]}:#{settings.database[:port]}@#{settings.database[:host]}/#{settings.database[:name]}")

  post '/sign-up/?' do
    if params[:email].match(%r{^.+@.+$})
      e = Email.new
      e.email = params[:email]
      e.save

      flash[:notice] = settings.messages[:success]
    else
      flash[:error] = settings.messages[:error]
    end

    erb :index
  end

  get '/' do
    @settings = settings

    erb :index
  end
end
