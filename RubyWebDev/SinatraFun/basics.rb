require 'sinatra'

get '/' do
  "Hello, World!"
end

get '/hello/:name' do
  "Hi #{params[:name]}!!"
end

get '/about' do
  "This is my first Sinatra app!"
end

get '/danny' do
  "Danny sucks!"
end

get '/more/*' do
  params[:splat]
end

get '/form' do
  erb :form
end

post '/form' do
  "You typed #{params[:message]}"
end