class Player
	attr_accessor :name, :bank_roll, :hand, :bet, :status

	def initialize(name, bank_roll)
		@hand = Hand.new
		@name = name
		@bank_roll = bank_roll
		@status = 'active'
	end

	def hit_or_stay
		if @hand.cards.size == 2
			puts "Would you like to hit or stay or double down? (h/s/dd)"
		else
			puts "Would you like to hit or stay? (h/s)"
		end

		case gets.chomp
		when 'h'
			return 'h'
		when 's'
			return 's'
		when 'dd'
			if @bet > @bank_roll/2
				puts "You don't have enough money to double down!"
				hit_or_stay
			elsif @hands.cards.size == 2
				return 'dd'
			else
				puts "You cannot currently double down!"
				hit_or_stay
			end
		end
	end
end

#*****************************

class Dealer
	attr_accessor :hand, :status

	def initialize
		@hand = Hand.new
		@status = "active"
	end

	def hit_or_stay
		if @hand.score < 17
			'h'
		else
			's'
		end
	end

end

#*****************************

class Deck
	attr_accessor :cards, :num_decks

	def initialize(num_decks)
		@cards = []
		@num_decks = num_decks
		generate_deck
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

	def generate_deck
		ranks = %w{ 2 3 4 5 6 7 8 9 10 Jack Queen King Ace }
		suits = %w{ Diamonds Hearts Spades Clubs }

		card_values = initialize_values

		@num_decks.times do 
			suits.each do |suit|
				ranks.each do |rank|
					card = Card.new(suit, rank)
					card.value = card_values[card.rank[0].to_sym]
					@cards << card
				end
			end
		end

		@cards.shuffle!
	end

end

#*****************************

class Hand
	attr_accessor :cards, :score

	def initialize
		@cards = []
		@score = 0
	end

	def hand_value
		@score = 0
		non_aces = @cards.select { |card| card.rank != "A"}
		aces = @cards.select { |card| card.rank == "A"}
		num_aces = aces.size

		non_aces.each { |card| @score += card.value }
		aces.each_with_index do |ace, i|
		if i == 0 && (score <= 10 - (num_aces - 1))
			@score += 11
		else
			@score += 1
		end
	end

	score
	end

	def print_hand(name = "Dealer")
		cards.each_with_index do |card, i|
			if name == "Dealer" && i == 0
				puts "#{name} Card #{i}: Hidden "
			else
				print "#{name} Card #{i}: "
				card.print_card
			end
		end
	end
end

#*****************************

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

#*****************************

class GameEngine
	attr_accessor :player, :dealer, :deck

	def initialize(player)
		@player = player
		@dealer = Dealer.new
		@deck = Deck.new(1)
	end

	def initial_deal
		@player.hand.cards << @deck.cards.pop
		@dealer.hand.cards << @deck.cards.pop
		@player.hand.cards << @deck.cards.pop
		@dealer.hand.cards << @deck.cards.pop
	end

	def print_hands
		@player.hand.print_hand(player.name)
		@dealer.hand.print_hand
	end

	def calculate_scores
		@player.hand.hand_value
		@dealer.hand.hand_value
	end

	def player_turn
		case @player.hit_or_stay
		when 'h'
			@player.hand.cards << @deck.cards.pop
			@player.status = 'active'
		when 's'
			@player.status = 'stay'
		when 'dd'
			@player.hand.cards << @deck.card.pop
			@player.status = 'active'
		end
	end

	def dealer_turn
		case @dealer.hit_or_stay
		when 'h'
			@dealer.hand.cards << @deck.cards.pop
			@dealer.hand.score = @dealer.hand.hand_value
			@dealer.status = "active"
		when 's'
			@dealer.status = "stay"
		end
	end

	def play(player)
		player_stay = false
		player_bust = false
		player_blackjack = false
		dealer_blackjack = false

		initial_deal

		print_hands
		calculate_scores

		if @player.hand.score == 21
			@player.status = "blackjack"
			puts "BLACKJACK!"
		elsif @dealer.hand.score == 21
			@dealer.status = "blackjack"
		end
		
		puts "Player Score: #{@player.hand.score}", ""

		until @player.status == "stay"
			player_turn
			print_hands
			puts "Player Score: #{@player.hand.score}", ""
		end
		puts "HEY"

		until @dealer.status == "stay"
			dealer_turn
		end

		print_hands
		puts "Player Score: #{@player.hand.score}", ""
		puts "Dealer Score: #{dealer.hand.score}", ""

		calculate_scores
		puts "Score: #{@player.hand.score}", ""


	end
end


puts "What is your name?"
name = gets.chomp
player = Player.new(name, 2000)

engine = GameEngine.new(player)
engine.play(player)
