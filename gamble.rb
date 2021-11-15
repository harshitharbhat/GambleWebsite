require 'dm-core'
require 'dm-migrations'

enable 'sessions'
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/gamble.db")

class Gamble
  include DataMapper::Resource
  property :id, Serial 
  property :username, String
  property :password, String
  property :win, Integer , default: 0
  property :lost, Integer, default: 0
end

DataMapper.auto_upgrade!
DataMapper.finalize

configure do
    enable :sessions
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/gamble.db")
end

post '/login' do
  user = Gamble.first(params[:username])
  print params[:password]
  if user!=nil && user.password == params[:password]
    session[:win] = 0
    session[:lost] = 0
    session[:password] = params[:password]
    session[:user] = params[:username]
    session[:total_win] = user.win
    session[:total_lost] = user.lost
    print "Hello"
    print session[:win]
    erb :gamble
  else 
    erb :login
  end
end

post '/gamble' do
  stake = params[:stake].to_i
  number = params[:number].to_i
  win = session[:win]
  lost = session[:lost]
  roll = rand(10) + 1
  if number == roll
    session[:win] = win +(stake*10)
    erb :gamble
  else
    session[:lost] = lost + stake
    erb :gamble
    end
end

post '/signup' do
  @gamble = Gamble.create(params[:gamble])
  print @gamble
  redirect to("/login")
end

get '/logout' do
  session[:total_win]+= session[:win]
  session[:total_lost]+= session[:lost]
  user = Gamble.first(params[:username])
  user.update(:win=>session[:total_win],:lost=>session[:total_lost])
  session[:user] = nil
  session[:password] = nil
  redirect to '/login'
end
