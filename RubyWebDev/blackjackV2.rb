class Player
	attr_accessor :name, :bank_roll, :hands, :bet

	def initialize(name, bank_roll)
		@name = name
		@bank_roll = bank_roll
	end


end

class Deck
	attr_accessor :cards, :num_decks

	def initialize(num_decks)
		@cards = []
		@num_decks = num_decks
	end

end

class Hand
	attr_accessor :cards, :score

	def initialize
		cards = []
	end

	def hand_value

	end

	def print_hand
		cards.each_with_index do |card| 
			put "Card #{i}: "
			card.print_card
		end
	end
end

class Card
	attr_accessor :suit, :rank, :value

	def initialize(suit, rank)
		@suit = suit
		@rank = rank
	end

	def print_card
		puts "#{rank} of #{suit}" 
	end
end

class GameEngine
	attr_accessor :player, :dealer

	def create_cards

	end

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
		deck = Deck.new(num_decks)
		card_values = initialize_values
		deck = Deck.new(num_decks)

		num_decks.times do 
			suits.each do |suit|
				ranks.each do |rank|
					card = Card.new(suit, rank)
					card.value = card_values[card.rank[0].to_sym]
					deck.cards << card
				end
			end
		end

		deck
	end

	def initialize_game

	end

	def play
		deck = generate_deck(1)

		deck.cards.each {|card| puts "#{card.rank} of #{card.suit}" }

		hand = Hand.new
		hand.cards << 5 #deck.cards.pop
		hand.print_hand
	end
end

engine = GameEngine.new
engine.play
