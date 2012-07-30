# go_fish.rb version 0.1

# initial setup for now; [important] stuff to remember for later:
	# players take turns asking for cards from one another
	# if a player gets what they ask for, they get another turn
	# if a player doesn't get what they ask for from another player, but get what they asked for from "going fishing,"
		# they get another turn - also, they must announce that they got what they asked for
	# a player CANNOT ask for something if THEY DO NOT have at least one of what they are asking for
	# when a player's hand contains all 4 suits of a RANK (King King King King), all of those cards are set aside
		# into a permanent score-pool for that player
	# player's score based on how many sets of 4 they have, via RANK (King King King King == a set)

require "./Deck"
require "./Player"
require "./Dealer"

class GoFish
	def initialize
		@player = Player.new
		@opponent = Dealer.new
	end

	@player.wipe_hand
	@opponent.wipe_hand

	@deck = Deck.new
	@deck.shuffle!

	# Initial deal; 7 cards go to each player.
	7.times { @player.deal(@deck.remove_top_card) }
	7.times { @opponent.deal(@deck.remove_top_card) }

	def do_you_have_any(requested_card)

	end
end