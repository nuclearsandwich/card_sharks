# go_fish.rb version 0.1

# initial setup for now; [important] stuff to remember for later:
	# players take turns asking for cards from one another
	# if a player has what the other asks for, the latter must turn over ALL cards of that RANK to the asking player
	# if a player gets what they ask for, they get another turn
	# if a player doesn't get what they ask for from another player, but get what they asked for from "going fishing,"
		# they get another turn - also, they must announce that they got what they asked for
	# a player CANNOT ask for something if THEY DO NOT have at least one of what they are asking for
	# when a player's hand contains all 4 suits of a RANK (King King King King), all of those cards are set aside
		# into a permanent score-pool for that player
	# player's score based on how many sets of 4 they have, via RANK (King King King King == a set)

	# to do/fix:
		# Player hand: Ace of Spades, Three of Hearts, King of Diamonds, Eight of Spades, Four of Clubs, King of Spades, Queen of Clubs.
		# Opponent hand: Six of Clubs, Nine of Spades, Two of Hearts, King of Clubs, Six of Diamonds, Queen of Diamonds, Nine of Diamonds.
		# You get the first turn.
		# Queen
		# The dealer does not have any Queens. You go fish, instead.
		# You fish a Seven of Hearts from the pool.
			# Dafuq? ^
			# Another test. v
		# Player hand: Two of Hearts, Eight of Hearts, Four of Diamonds, Jack of Diamonds, Ace of Clubs, Five of Spades, Five of Diamonds.
		# Dealer hand: Ace of Hearts, Queen of Hearts, Three of Hearts, Nine of Clubs, Queen of Spades, Four of Spades, Jack of Spades.
		# You get the first turn.
		# Ace
		# The dealer had a Ace; you add the Ace of Hearts to your hand.
		# Four
		# The dealer does not have any Fours. You go fish, instead.
		# You fish a King of Hearts from the pool.
			# Sometimes it finds it, sometimes not?

		# go_fish.rb:54:in `block in dealers_turn': undefined method `ranks' for Queen of Hearts:Card (NoMethodError)
		 # Possible fix: use gsub to strip everything but the first word (rank) from the card.

		# Would you like to play a game of Go Fish?
		# yes
		# Player hand: Eight of Hearts, Jack of Spades, Queen of Spades, Eight of Clubs, Ten of Hearts, Two of Diamonds, Two of Spades.
		# Dealer hand: Three of Spades, Four of Spades, Four of Clubs, Five of Hearts, King of Spades, Seven of Diamonds, Jack of Hearts.
		# You get the first turn.
		# What rank do you want to ask your opponent for?
		# Jack
		# The dealer does not have any Jacks. You go fish, instead.
		# You fish a Jack of Diamonds from the pool.
		# You got what you asked for! You get another turn.
		# What rank do you want to ask your opponent for?
		# Three
		# The dealer had a Three; you add the Three of Spades to your hand.
		# What rank do you want to ask your opponent for?
			# Some good, some bad, here:
				# Bad: The player can ask for something they don't posess in their hand (Three).
				# Bad: The program is not recognizing a Jack in the dealer's hand...
				# Good: ...though, oddly enough, recognized the three.
				# Good: Hey, the player got a Jack from going fishing! The program gives the player another turn, as appropriate.

		# While testing the .gsub in dealers_turn:
			# Player hand: Eight of Diamonds, Ace of Diamonds, Three of Clubs, Nine of Clubs, Five of Spades, Queen of Spades, Ten of Clubs.
			# Dealer hand: Ace of Clubs, Jack of Diamonds, King of Diamonds, Ace of Spades, Queen of Hearts, Nine of Diamonds, Six of Diamonds.
			# You get the first turn.
			# What rank do you want to ask your opponent for?
			# Ace
			# The dealer had a Ace; you add the Ace of Clubs to your hand.
			# What rank do you want to ask your opponent for?
				# The dealer had two Aces - Clubs and Spades - but the player was not given both, only one.
				# [Par of the] problem is line 141 - the program calls ask_for befoing finishing going through the entire hand
				# This may also have to do with why the program isn't finding a rank sometimes:
			# Ace
			# The dealer does not have any Aces. You go fish, instead.
			# You fish a Jack of Hearts from the pool.
				# The program isn't going far enough through the hand to find the rank.

		# Also, the .gsub doesn't quite work:
			# go_fish.rb:92:in `block in dealers_turn': undefined method `gsub' for Jack of Diamonds:Card (NoMethodError)


require "./Deck"
require "./Player"
require "./Dealer"

class GoFish
	def initialize
		@player = Player.new
		@dealer = Dealer.new
	end

	def round_of_go_fish
		@player.wipe_hand
		@dealer.wipe_hand

		@deck = Deck.new
		@deck.shuffle!

		# Initial deal; 7 cards go to each player.
		7.times { @player.deal(@deck.remove_top_card) }
		7.times { @dealer.deal(@deck.remove_top_card) }

		# Ultimately, these two lines will be removed. Keep for now, while testing
		puts "Player hand: #{@player.tell_hand}."
		puts "Dealer hand: #{@dealer.tell_hand}."

		def dealers_turn
			# dealer gets a pool of ranks to chose from:
			cards_to_chose_from = []
			# populate the choice-pool:
			@dealer.hand.each do |card|
				# .gsub(/( of Spades|| of Diamonds|| of Hearts|| of Clubs)/, "")
					# ...is not being recognized. Trying to be too crafty by putting or's into a gsub?
				# .gsub(/( of Clubs),( of Diamonds),( of Hearts),( of Spades)/, "")
					# Does not work either, after a test.

				# Chaining .gsubs seems to work, instead:
				card.gsub(/( of Clubs)/, "").gsub(/( of Diamonds)/, "").gsub(/( of Hearts)/, "").gsub(/( of Spades)/, "")
			end

			# randomly determine which card the dealer will ask for:
			random_card = rand(cards_to_chose_from.length)

			# ask for it:
			puts "The dealer asks for your #{random_card.ranks}s."
		end

		def go_fish(card)
			card_to_deal = @deck.remove_top_card
			puts "You fish a #{card_to_deal} from the pool."
			@player.deal(card_to_deal)

			# The player gets another turn if they got what they asked for:
			if card_to_deal.include?(card)
				puts "You got what you asked for! You get another turn."
				ask_for
			else
				dealers_turn
			end
		end

		def do_you_have_any(requested_card)
			@dealer.hand.each do |card|
				if card.include?(requested_card)
					@player.deal(@dealer.hand.delete(card))
					puts "The dealer had a #{requested_card}; you add the #{card} to your hand."
					ask_for
				else
					puts "The dealer does not have any #{requested_card}s. You go fish, instead."
					# The player is told to go fish, if any cards remain in the deck:
					go_fish(requested_card) if @deck.remove_top_card != nil
					# Else, go to dealer's turn:
					dealers_turn
				end
			end
		end

		def ask_for
			puts "What rank do you want to ask your opponent for?"
			requested_card = gets.chomp
			do_you_have_any(requested_card)
		end

		# determine who goes first
		def who_goes_first
			# In the final version, uncomment the following line. Just for testing, player gets the first turn.
			# if rand(2) == 1
			if 1 == 1	
				puts "You get the first turn."
				ask_for
			else
				puts "The dealer gets the first turn."
				dealers_turn
			end
		end

		who_goes_first
	end
end

def play_a_game
	puts "Would you like to play a game of Go Fish?"
	if gets.chomp.downcase == "yes"
		GoFish.new.round_of_go_fish
	else 
		puts "Alrighty then, another time!"
		exit 0
	end
end

play_a_game
