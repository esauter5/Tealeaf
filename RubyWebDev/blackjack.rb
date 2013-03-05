ranks = %w{ 2 3 4 5 6 7 8 9 10 Jack Queen King Ace }
suits = %w{ Diamonds Hearts Spades Clubs }

deck = ranks.product(suits).map{|card| card.join(" of ")}.shuffle

#puts deck

cardValues = Hash.new(0)

(2..10).each {|i| cardValues[i.to_s.to_sym] = i }
cardValues[:J] = 10
cardValues[:Q] = 10
cardValues[:K] = 10
cardValues[:A] = 11

playerCards = []
dealerCards = []
playerCards << deck.pop
dealerCards << deck.pop
playerCards << deck.pop
dealerCards << deck.pop
playerScore = 0
dealerScore = 0

playerStay = false

playerCards.each_with_index do |v,i| 
	puts "Player Card #{i+1}: #{v}" 
	playerScore += cardValues[v[0].to_sym]
end

dealerCards.each_with_index do |v,i| 
	if i == 0
		puts "Dealer Card #{i+1}: Hidden" 
	else
		puts "Dealer Card #{i+1}: #{v}" 
	end
end



until playerStay == true
	puts "Would you like to hit or stay?"

	case gets.chomp
		when 'hit'
			card = deck.pop
			puts card
			playerScore += cardValues[card[0].to_sym]
			playerCards << card
			puts "Player Score: #{playerScore}"
		when 'stay'
			playerStay = true
	end
end

#puts deck


