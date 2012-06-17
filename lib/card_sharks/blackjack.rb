require "./Deck"
require "./Player"
require "./Dealer"

# Blackjack.rb version 3.1

# Notes on progress / current problems:
	# 37: invalid break
	# 21:in `round_of_blackjack': undefined method `credits' for #<Player:0x827260 @credits=150, @hand=[]> (NoMethodError) - resolved
	# 25:in `block in round_of_blackjack': undefined method `remove_top_card' for #<Array:0x827ea4> (NoMethodError)

class Blackjack
	def initialize
		@deck = Deck.new.shuffle!
		
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
		puts "The dealer has been dealt two cards, and is showing #{@dealer.hand[1]}."

		# First, the player's turn:
		hit_or_stay

		def hit_or_stay
			# # break if initial deal == 21
			if evaluate_hand_score(@player.hand) == 21
				break
			end

			until gets.chomp.downcase == "stay"
				@player.deal(@deck.remove_top_card)

				if evaluate_hand_score(@player.hand) == 21
					# Break player out of until-loop when they hit towards 21
					puts "You have a score of 21 with: #{@player.hand.join(", ")}."
					break
				else
					if evaluate_hand_score(@player.hand) > 21
						puts "You busted with #{evaluate_hand_score(@player.hand)}."
						end_round("lose")
					else
						hit_or_stay
					end
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
				if hand[x].include?("Jack") || hand[x].include?("Queen") || hand[x].include?("King")
					hand_score += 10
					x += 1
				elsif hand[x].include?("Ace")
					if (hand_score + 11) > 21
						hand_score += 1
					else
						hand_score += 11
					end 
					x += 1	
				elsif
					# Strip everything but the numbers from the string
					hand_score += hand[x].gsub(/[^0-9]/, '').to_i
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
			if conditional == "win"
				@player.credits += (@player_bid * 2)
				# Double the player's bid and add that number to their credits pool.
			elsif conditional == "lose"
				@player.credits -= @player_bid
				# Deduct the player's bid from their credit pool.
			else
				# On a push (tie), do nothing to the player's credit pool.
			end
		end

		# Save score as an integer in players_score
		players_score = evaluate_hand_score(@player.hand)
		# Determine if the player's hand is a blackjack
		player_has_blackjack = is_blackjack(@player.hand)

		#Dealer's turn
		# Until the value of dealers_hand > 15, they hit
		until evaluate_hand_score(@dealer.hand) > 15
			was_dealt = @dealer.deal(@deck.remove_top_card)
			puts "The dealer adds a #{was_dealt} to their hand."
		end
		# The dealer busts if over 21
		if dealers_score > 21
			puts "The dealer busts with #{dealers_score}."
			end_round("win")
		end
		dealers_score = evaluate_hand_score(@dealer.hand)
		dealer_has_blackjack = is_blackjack(@dealer.hand)

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
