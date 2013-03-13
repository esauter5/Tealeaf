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

  def print_hand(name = "Player", status = "hit")
    cards.each_with_index do |card, i|
      if name == "Dealer" && i == 0 && status == "hit"
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

  def print_hands(status = "hit")
    @player.hand.print_hand(player.name)
    @dealer.hand.print_hand("Dealer",status)
  end

  def calculate_scores
    @player.hand.hand_value
    @player.status = "bust" if @player.hand.score > 21
    @dealer.hand.hand_value
    @dealer.status = "bust" if @dealer.hand.score > 21
  end

  def player_decision
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

  def dealer_decision
    case @dealer.hit_or_stay
    when 'h'
      @dealer.hand.cards << @deck.cards.pop
      @dealer.hand.score = @dealer.hand.hand_value
      @dealer.status = "active"
    when 's'
      @dealer.status = "stay"
    end
  end

  def player_turn
    until @player.status == "stay" || @player.status == "bust"
      player_decision
      print_hands
      calculate_scores
      print_player_score
    end
  end

  def dealer_turn
    until @dealer.status == "stay" || @dealer.status == "bust"
      dealer_decision
      calculate_scores
    end
  end

  def check_blackjack
    if @player.hand.score == 21
      @player.status = "blackjack"
      puts "BLACKJACK!"
    elsif @dealer.hand.score == 21
      @dealer.status = "blackjack"
    end
  end

  def print_player_score
    puts "Player Score: #{@player.hand.score}", ""
  end

  def print_dealer_score
    puts "Dealer Score: #{@dealer.hand.score}", ""
  end

  def determine_winner
    if @player.hand.score == @dealer.hand.score
      puts "TIE!!!"
    elsif @player.status == "blackjack"
      puts "YOU WIN!!!"
    elsif @dealer.status == "blackjack"
      puts "DEALER WINS!!!"
    elsif @player.status == "bust"
      puts "BUST!!! YOU LOSE!!!"
    elsif @dealer.status == "bust"
      puts "DEALER BUST!!! YOU WIN!!!"
    elsif @player.hand.score > @dealer.hand.score
      puts "YOU WIN!!!"
    else
      puts "DEALER WINS!!!"
    end
  end

  def play(player)
    initial_deal

    print_hands
    calculate_scores
    check_blackjack

    print_player_score

    unless @player.status == "blackjack" || @dealer.status == "blackjack"
      player_turn
      dealer_turn
    end

    print_hands("stay")
    print_player_score
    print_dealer_score

    determine_winner
  end
end


puts "What is your name?"
name = gets.chomp

continue = 'y'

until continue == 'n'
  player = Player.new(name, 2000)
  engine = GameEngine.new(player)
  engine.play(player)
  puts "Would you like to play again?"
  continue = gets.chomp
end



