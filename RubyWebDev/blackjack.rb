
def initialize_values
	cardValues = Hash.new(0)
	(2..9).each {|i| cardValues[i.to_s.to_sym] = i }
	cardValues[:"1"] = 10
	cardValues[:J] = 10
	cardValues[:Q] = 10
	cardValues[:K] = 10
	cardValues[:A] = 11

	cardValues
end

def generate_deck
	ranks = %w{ 2 3 4 5 6 7 8 9 10 Jack Queen King Ace }
	suits = %w{ Diamonds Hearts Spades Clubs }
	deck = ranks.product(suits).map{|card| card.join(" of ")}.shuffle
end

def deal_card(hand,deck)
	hand << deck.pop
end

def print_player_cards(playerCards)
	playerCards.each_with_index do |v,i| 
	puts "Player Card #{i+1}: #{v}" 
	#playerScore += cardValues[v[0].to_sym]
end
end

def print_dealer_cards(dealerCards, playerStay)
	dealerCards.each_with_index do |v,i| 
		if i == 0 && playerStay == false
			puts "Dealer Card #{i+1}: Hidden" 
		else
			puts "Dealer Card #{i+1}: #{v}" 
		end
	end
end

def hand_value(hand, cardValues)
	score = 0

	hand.each_with_index do |v,i|
		if score > 10 && v[0] == "A"
			score += 1
		else
			puts "Value #{v} #{cardValues[v[0].to_sym]}" 
			score += cardValues[v[0].to_sym]
		end
	end

	score
end

def determine_winner(playerScore, dealerScore)
	if playerScore > dealerScore
		puts "You win!!!"
	elsif dealerScore > playerScore
		puts "Dealer wins!!!"
	else
		puts "Tie!!!"
	end
end

def play
	playerScore = 0
	dealerScore = 0

	playerStay = false
	playerBust = false

	cardValues = initialize_values

	deck = generate_deck

	playerCards = []
	dealerCards = []

	2.times { deal_card(playerCards, deck) }
	2.times { deal_card(dealerCards, deck) }

	playerScore = hand_value(playerCards, cardValues)
	dealerScore = hand_value(dealerCards, cardValues)


	print_player_cards(playerCards)
	print_dealer_cards(dealerCards,playerStay)

	puts "Player score is: #{playerScore}"


	until playerStay == true || playerBust == true
		puts "Would you like to hit or stay?"

		case gets.chomp
			when 'hit'
				deal_card(playerCards,deck)
				playerScore = hand_value(playerCards,cardValues)
				print_player_cards(playerCards)
				#playerScore += cardValues[card[0].to_sym]
				#playerCards << card
				puts "Player Score: #{playerScore}"

				playerBust = true if playerScore > 21
			when 'stay'
				playerStay = true
		end
	end

	if playerBust == true
		puts "You BUSTED!!! Dealer WINS!!!"
	elsif playerStay == true
		until dealerScore >= 17
			deal_card(dealerCards, deck)
			dealerScore = hand_value(dealerCards, cardValues)
		end

		print_dealer_cards(dealerCards, playerStay)
		puts "Dealer Score: #{dealerScore}"

		if dealerScore > 21
			puts "Dealer BUSTED!!! You win!!!"
		else
			determine_winner(playerScore, dealerScore)
		end
	end
end

play
playAgain = true

until playAgain == false
	puts "Do you want to play again? (y/n)"
	
	case gets.chomp	
		when 'y'
			play
		when 'n'
			playAgain = false
	end
end




