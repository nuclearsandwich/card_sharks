require "./Deck"
require "./Player"
require "./Dealer"

# Blackjack.rb version 3.1

# Notes on progress / current problems:
	# Would you like to play a round of blackjack?
	# yes
	# How many of your 150 credits would you like to wager?
	# 25
	# You have been dealt: Two of Clubs, Seven of Hearts.
	# The dealer has been dealt two cards, and is showing Four of Spades.
	# hit   <- giant problem here: player is not being told of their updated hand,
	# hit   <- also, they are not being asked hit or stay
	# hit
	# You have a score of 21 with: Two of Clubs, Seven of Hearts, Three of Spades, Six of Spades, Three of Hearts.
	# hit   <- aaaaaand they can hit on a 21.
	# You busted with 31.
	# blackjack.rb:127:in `-': nil can't be coerced into Fixnum (TypeError)   <- has to do with deducting the player's bid from their credit pool

	# You have been dealt: Eight of Hearts, Queen of Hearts.
	# The dealer has been dealt two cards, and is showing Ace of Diamonds.
	# Hit or stay?
	# stay
	# Your 18 whomps the dealer's meager 16.
	# blackjack.rb:133:in `end_round': undefined method `*' for nil:NilClass (NoMethodError)
		# ^ Has to do with adding (@player_bid * 2) to @player.credits
		# On the plus side, it is adding card values properly (for the most part)

class Blackjack
	def initialize
		@deck = Deck.new
		@deck.shuffle!

		@player = Player.new
		@dealer = Dealer.new
	end

	def round_of_blackjack
		@player_bid = @player.make_bid
		@player_credits = @player.credits

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
					puts "You have a score of 21 with: #{@player.hand.join(", ")}."
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
			# If hand contains an Ace, remove it from the array, and .push it to the last place
			# This way, Aces get evaluated last (11 or 1)
			y = 0        # indexing for the Ace-checking
			while y < hand.length
				if hand[y].include?("Ace")
					hand.push(hand.delete_at(y))
					y += 1
				else
					y += 1
				end
			end

			hand_score = 0
			x = 0       # indexing for the hand scoring, below
			while x < hand.length
				if hand[x].include?("Ace")
					if (hand_score + 11) > 21
						hand_score += 1
					else
						hand_score += 11
					end
					x += 1
				else
					hand_score += hand[x].value.to_i
					x += 1
				end
			end
			hand_score
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
				@player.credits += (@player_bid * 2)
				play_a_game
			elsif conditional == "lose"
				# Deduct the player's bid from their credit pool.
				@player.credits -= @player_bid
				play_a_game
			else
				# On a push (tie), do nothing to the player's credit pool.
				puts "This round was a push."
				play_a_game
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
# ^ This end ends the Blackjack class

def play_a_game
	puts "Would you like to play a round of blackjack?"
	if gets.chomp.downcase == "yes"
		Blackjack.new.round_of_blackjack
	else 
		puts "Alrighty then, another time!"
	end
end

play_a_game
