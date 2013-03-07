
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

def generate_deck(numDecks)
	ranks = %w{ 2 3 4 5 6 7 8 9 10 Jack Queen King Ace }
	suits = %w{ Diamonds Hearts Spades Clubs }
	tempDeck = ranks.product(suits).map{|card| card.join(" of ")}
	deck = []
	numDecks.times { deck.concat(tempDeck) }

	deck
end

def deal_card(hand,deck)
	hand << deck.pop
end

def print_player_cards(playerCards)
	playerCards.each_with_index do |v,i| 
		puts "#{$name} Card #{i+1}: #{v}" 
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
		puts " " if !playerStay
end

def hand_value(hand, cardValues)
	score = 0
	hasAce = false

	hand.each_with_index do |v,i|
		if score > 10 && v[0] == "A"
			score += 1
			hasAce = true
		elsif v[0] == "A"
			score += cardValues[v[0].to_sym]
			hasAce = true
		elsif score + cardValues[v[0].to_sym] > 21 && hasAce
			score += (cardValues[v[0].to_sym] - 10)
		else
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

def play(deck, fullDeckSize)
	playerScore = 0
	dealerScore = 0

	playerStay = false
	playerBust = false
	playerBlackjack = false
	dealerBlackjack = false

	cardValues = initialize_values

	#puts "Deck size: #{deck.size}"

	playerCards = []
	dealerCards = []

deal_card(playerCards, deck)
deal_card(dealerCards, deck)
deal_card(playerCards, deck)
deal_card(dealerCards, deck)

	playerScore = hand_value(playerCards, cardValues)
	dealerScore = hand_value(dealerCards, cardValues)

	playerBlackjack = true if playerScore == 21
	dealerBlackjack = true if dealerScore == 21


	print_player_cards(playerCards)
	print_dealer_cards(dealerCards,playerStay)

	puts "=>#{$name}'s score: #{playerScore}"
	puts " "


	until playerStay || playerBust || playerBlackjack || dealerBlackjack
		puts "Would you like to hit or stay? (h/s)"

		case gets.chomp
			when 'h'
				deal_card(playerCards,deck)
				playerScore = hand_value(playerCards,cardValues)
				print_player_cards(playerCards)
				print_dealer_cards(dealerCards,playerStay)
				#playerScore += cardValues[card[0].to_sym]
				#playerCards << card
				puts "=>#{$name}'s score: #{playerScore}"

				playerBust = true if playerScore > 21

			when 's'
				playerStay = true
		end
	end


	if playerBlackjack
		puts "You have BLACKJACK!!! You WIN!!!"
	elsif dealerBlackjack
		puts "Dealer BLACKJACK!!! Dealer WINS!!!"
	elsif playerBust
		puts "You BUSTED!!! Dealer WINS!!!"
	elsif playerStay
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





puts "What is your name?"
$name = gets.chomp

puts "How many decks would you like to use?"
numDecks = gets.chomp.to_i
fullDeck = generate_deck(numDecks)
fullDeckSize = fullDeck.size

deck = fullDeck.shuffle

play(deck,fullDeckSize)
playAgain = true

until playAgain == false
	puts "Do you want to play again? (y/n)"
	
	case gets.chomp	
		when 'y'
			puts "*******************************"
			if deck.size < fullDeckSize * 0.25
				deck = generate_deck(fullDeckSize/52).shuffle
			end
			play(deck,fullDeckSize)
		when 'n'
			playAgain = false
	end
end




