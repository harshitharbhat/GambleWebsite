
require 'sinatra'
require 'sinatra/reloader'

require './gamble'

get '/' do
  @title = "home page"
  erb :index  
end

get '/login' do
  @title = "login page"
  erb :login
end

get '/signup' do
  @title = "signup"
  erb :signup
end

