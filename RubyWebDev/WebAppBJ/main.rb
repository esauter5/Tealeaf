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
  ranks = %w{ 2 3 4 5 6 7 8 9 10 jack queen king ace}
  suits = %w{ diamonds hearts clubs spades}
  cards = ranks.product(suits).map { |card| card.join(" of ") }
  session[:deck] = cards.shuffle
  session[:player_cards] = []
  session[:dealer_cards] = []
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  @player_stay = false

  erb :game
end

get '/new_player' do
  erb :name_form
end

post '/new_player' do
  session[:name] = params[:name]
  redirect '/'
end

get '/welcome' do

end

post '/game/hit' do
  session[:player_cards] << session[:deck].pop

  erb :game
end

post '/game/stay' do
  session[:player_turn] = false
  session[:dealer_cards] << session[:deck].pop
  @player_stay = true

  erb :game
end


