require "./Deck"
require "./Player"
require "./Dealer"
require "./blackjack_value.rb"

# Blackjack.rb version 3.1

# Notes on progress / current problems:
	# Would you like to play a round of blackjack?
	# yes
	# How many of your 150 credits would you like to wager?
	# 25
	# You have been dealt: King of Hearts, Five of Clubs.
	# The dealer has been dealt two cards, and is showing Seven of Clubs.
	# Hit or stay?
	# hit
	# Your hand contains King of Hearts, Five of Clubs, Six of Hearts.
	# Your hand's score is 21.
	# Your 21 whomps the dealer's meager 17.
	# This round, the dealer's hand contained: King of Spades, Seven of Clubs.
	# Would you like to play a round of blackjack?
	# yes
	# How many of your 200 credits would you like to wager?
	# 10 
	# You have been dealt: King of Hearts, Five of Clubs, Six of Hearts, Ace of Hearts, Nine of Diamonds.
	# The dealer has been dealt two cards, and is showing Seven of Clubs.
	# Hit or stay?
		# Well, well, well...fix one thing, break another. xD
		# Credits are now being deducted, but wow - look at that initial deal.
		
		# In my attempt to alter play_a_game, I thought the changes would keep track of the credits, but
		# didn't take into consideration the persistence of the player's hand.

		# Fix I am considering:
			# Give round_of_blackjack a parameter - as was done to play_a_game - and if x is a certain value,
			# wipe the player's hand, the dealer's hand, and create a brand new deck.

	# Also, tell player their bid & credits after a round

	# Condense lines 146 & 147 (dealer's until-loop)

class Blackjack
	def initialize
		# Ripped the deck out of here, and put it onto lines 59-60

		@player = Player.new
		@dealer = Dealer.new
	end

	def round_of_blackjack
		@player_bid = @player.make_bid
		@player_credits = @player.credits

		# Reset the hands of the player and dealer, ensuring an empty array each round
		@player.wipe_hand
		@dealer.wipe_hand

		# New, shuffled deck each round
		@deck = Deck.new
		@deck.shuffle!

		# Deal two cards to player ("physically" removing them from @deck)
		2.times { @player.deal(@deck.remove_top_card) }
		# Then ditto for the dealer
		2.times { @dealer.deal(@deck.remove_top_card) }
		# Announce the second of the dealer's two cards
		puts "You have been dealt: #{@player.tell_hand}."
		puts "The dealer has been dealt two cards, and is showing #{@dealer.hand[1]}."

		def hit_or_stay
			puts "Hit or stay?"
			until gets.chomp.downcase == "stay"
				@player.deal(@deck.remove_top_card)
				puts "Your hand contains #{@player.tell_hand}."

				if evaluate_hand_score(@player.hand) == 21
					# Break player out of until-loop when they hit towards 21
					puts "Your hand's score is 21."
					break
				elsif
					if evaluate_hand_score(@player.hand) > 21
						puts "You busted with #{evaluate_hand_score(@player.hand)}."
						end_round("lose")
					end
				else
					puts "Hit or stay?"
				end
			end
		end

	  def evaluate_hand_score(hand)
	  	hand_score = (BlackjackValue.new(hand)).value
	  end

		def is_blackjack(hand)
			x = 0     # Hand indexing
			has_jack = false
			has_ace = false

			while x < hand.length
				if hand[x].include?("Ace") == true
					has_ace = true
					x = hand.length
				else
					x += 1
				end
			end

			x = 0     # Reset x

			while x < hand.length
				if hand[x].include?("Jack") == true
					has_jack = true
					x = hand.length
				else
					x += 1
				end
			end

			if has_jack == true && has_ace == true && hand.length == 2
				true
			else
				false
			end
		end

		def end_round(conditional)
			puts "This round, the dealer's hand contained: #{@dealer.tell_hand}."
			if conditional == "win"
				# Double the player's bid and add that number to their credits pool.
				@player.update_credits(@player_bid * 2)
				play_a_game(0)
			elsif conditional == "lose"
				# Deduct the player's bid from their credit pool.
				@player.update_credits(@player_bid * -1)
				play_a_game(0)
			else
				# On a push (tie), do nothing to the player's credit pool.
				puts "This round was a push."
				play_a_game(0)
			end
		end

		# First, the player's turn:
		if evaluate_hand_score(@player.hand) == 21
			# If initial deal == 21, skip hit_or_stay
		else
			# Go into hit_or_stay if initial deal != 21
			hit_or_stay
		end

		# Save score as an integer in players_score
		players_score = evaluate_hand_score(@player.hand)
		# Determine if the player's hand is a blackjack
		player_has_blackjack = is_blackjack(@player.hand)

		#Dealer's turn
		dealers_score = evaluate_hand_score(@dealer.hand)
		dealer_has_blackjack = is_blackjack(@dealer.hand)
		# Until the value of dealers_hand > 15, they hit
		until dealers_score > 15
			was_dealt = @deck.deck(0)
			@dealer.deal(@deck.remove_top_card)
			puts "The dealer adds a #{was_dealt} to their hand."
			dealers_score = evaluate_hand_score(@dealer.hand)
		end
		# The dealer busts if over 21
		if dealers_score > 21
			puts "The dealer busts with #{dealers_score}."
			end_round("win")
		end

		# Final scoring
		# First, does anyone have a Blackjack?
		if player_has_blackjack == true || dealer_has_blackjack == true
			if player_has_blackjack == true && dealer_has_blackjack == false
				puts "Your Blackjack trumps the dealer."
				end_round("win")
			elsif player_has_blackjack == false && dealer_has_blackjack == true
				puts "The dealer's Blackjack trumps your hand."
				end_round("lose")
			elsif player_has_blackjack == true && dealer_has_blackjack == true
				puts "Both you and the dealer have a Blackjack."
				end_round("push")
			end

		# Second, if no Blackjacks are in anyone's hand:
		elsif players_score > dealers_score
			puts "Your #{players_score} whomps the dealer's meager #{dealers_score}."
			end_round("win")
		elsif dealers_score > players_score
			puts "The dealer's #{dealers_score} eats your #{players_score} for breakfast."
			end_round("lose")
		else
			end_round("push")
		end
	end
end

def play_a_game(x)
	puts "Would you like to play a round of blackjack?"
	if gets.chomp.downcase == "yes"
		if x == 1
			Blackjack.new.round_of_blackjack
		else
			round_of_blackjack
		end
	else 
		puts "Alrighty then, another time!"
	end
end

play_a_game(1)
