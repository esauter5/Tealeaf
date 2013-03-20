require 'rubygems'
require 'sinatra'

set :sessions, true

get '/' do
  if  session[:name]
    redirect '/game'
  else
    redirect '/new_player'
  end
end

get '/game' do
  erb :welcome
end

get '/new_player' do
  erb :name_form
end

post '/new_player' do
  session[:name] = params[:name]
  redirect '/'
end




