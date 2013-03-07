
def initialize_values
	card_values = Hash.new(0)
	(2..9).each {|i| card_values[i.to_s.to_sym] = i }
	card_values[:"1"] = 10 #Represents 10 since I read first character
	card_values[:J] = 10
	card_values[:Q] = 10
	card_values[:K] = 10
	card_values[:A] = 11

	card_values
end

def generate_deck(num_decks)
	ranks = %w{ 2 3 4 5 6 7 8 9 10 Jack Queen King Ace }
	suits = %w{ Diamonds Hearts Spades Clubs }
	temp_deck = ranks.product(suits).map{|card| card.join(" of ")}
	deck = []
	num_decks.times { deck.concat(temp_deck) }

	deck
end

def deal_card(hand,deck)
	hand << deck.pop
end

def print_player_cards(player_cards)
	player_cards.each_with_index do |v,i| 
		puts "#{$name} Card #{i+1}: #{v}" 
	end
end

def print_dealer_cards(dealer_cards, player_stay)
	dealer_cards.each_with_index do |v,i| 
		if i == 0 && player_stay == false
			puts "Dealer Card #{i+1}: Hidden" 
		else
			puts "Dealer Card #{i+1}: #{v}" 
		end
	end
		puts " " if !player_stay
end

def hand_value(hand, card_values)
	score = 0
	has_ace = false

	hand.each_with_index do |v,i|
		if score > 10 && v[0] == "A"
			score += 1
			has_ace = true
		elsif v[0] == "A"
			score += card_values[v[0].to_sym]
			has_ace = true
		elsif score + card_values[v[0].to_sym] > 21 && has_ace
			score += (card_values[v[0].to_sym] - 10)
		else
			score += card_values[v[0].to_sym]
		end
	end

	score
end

def determine_winner(player_score, dealer_score)
	if player_score > dealer_score
		puts "You win!!!"
		$bank += $bet * $dd_factor
	elsif dealer_score > player_score
		puts "Dealer wins!!!"
		$bank -= $bet * $dd_factor
	else
		puts "Tie!!!"
	end
end

def play(deck, full_deck_size)
	player_score = 0
	dealer_score = 0

	player_stay = false
	player_bust = false
	player_blackjack = false
	dealer_blackjack = false

	$dd_factor = 1

	card_values = initialize_values

	player_cards = []
	dealer_cards = []

	deal_card(player_cards, deck)
	deal_card(dealer_cards, deck)
	deal_card(player_cards, deck)
	deal_card(dealer_cards, deck)

	player_score = hand_value(player_cards, card_values)
	dealer_score = hand_value(dealer_cards, card_values)

	player_blackjack = true if player_score == 21
	dealer_blackjack = true if dealer_score == 21


	print_player_cards(player_cards)
	print_dealer_cards(dealer_cards,player_stay)

	can_dd = true

	puts "=>#{$name}'s score: #{player_score}"
	puts " "


	until player_stay || player_bust || player_blackjack || dealer_blackjack
		if can_dd
			puts "Would you like to hit or stay or double down? (h/s/dd)"
		else
			puts "Would you like to hit or stay? (h/s)"
		end

		case gets.chomp
			when 'h'
				deal_card(player_cards,deck)
				player_score = hand_value(player_cards,card_values)
				print_player_cards(player_cards)
				print_dealer_cards(dealer_cards,player_stay)
				puts "=>#{$name}'s score: #{player_score}"
				can_dd = false
				player_bust = true if player_score > 21

			when 's'
				player_stay = true
			when 'dd'
				if $bet > $bank/2
					puts "You don't have enough money to double down!"
					can_dd = false
				elsif can_dd
					$dd_factor = 2
					deal_card(player_cards,deck)
					player_score = hand_value(player_cards,card_values)
					print_player_cards(player_cards)
					print_dealer_cards(dealer_cards,player_stay)
					puts "=>#{$name}'s score: #{player_score}"
					can_dd = false
					player_bust = true if player_score > 21
					player_stay = true
				else
					puts "You cannot currently double down!"
				end
		end
	end


	if player_blackjack
		puts "You have BLACKJACK!!! You WIN!!!"
		$bank += $bet * 1.5
	elsif dealer_blackjack
		puts "Dealer BLACKJACK!!! Dealer WINS!!!"
		$bank -= $bet
	elsif player_bust
		puts "You BUSTED!!! Dealer WINS!!!"
		$bank -= $bet * $dd_factor
	elsif player_stay
		until dealer_score >= 17
			deal_card(dealer_cards, deck)
			dealer_score = hand_value(dealer_cards, card_values)
		end

		print_dealer_cards(dealer_cards, player_stay)
		puts "Dealer Score: #{dealer_score}"

		if dealer_score > 21
			puts "Dealer BUSTED!!! You win!!!"
			$bank += $bet * $dd_factor
		else
			determine_winner(player_score, dealer_score)
		end
	end

end


$bank = 2000
$bet = 5



puts "What is your name?"
$name = gets.chomp

puts "How many decks would you like to use?"
num_decks = gets.chomp.to_i
full_deck = generate_deck(num_decks)
full_deck_size = full_deck.size

deck = full_deck.shuffle

puts "Current money: #{$bank}", ""
puts "How much would you like to bet?"
			$bet = gets.chomp.to_i

play(deck,full_deck_size)
puts "Current money: #{$bank}", ""
play_again = true

until play_again == false
	puts "Do you want to play again? (y/n)"
	
	case gets.chomp	
		when 'y'
			puts "*******************************"
			puts "Current money: #{$bank}", ""
			puts "How much would you like to bet?"
			$bet = gets.chomp.to_i

			if $bet <= $bank
				if deck.size < full_deck_size * 0.25
					deck = generate_deck(full_deck_size/52).shuffle
				end
				if $bank == 0
					play_again = false
					puts "You are broke. Consider attending Gambler's Anonymous meetings"
				else
					play(deck,full_deck_size)
					puts "Current money: #{$bank}", ""
				end
			elsif $bank > 5
				puts "Sorry you don't have enough to bet that amount! Please bet a lower amount"
			else
				puts "You are broke. Consider attending Gambler's Anonymous meetings"
				play_again = false
			end
		when 'n'
			play_again = false
	end
end




