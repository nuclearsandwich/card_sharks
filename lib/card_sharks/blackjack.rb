# Blackjack.rb version 3.1

# Notes on progress / current problems:



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

		# First, the player's turn:
		# Ask if hit/stay, and loop if hit
		if @player.evaluate_hand_score(@player) == 21
			# If their initial deal already == 21, go to end_round
			end_round("21")
		else
			hit_or_stay
		end

		def hit_or_stay
			until gets.chomp.downcase == "stay"
				@player.deal(@deck.remove_top_card)

				if @player.hand_value == 21
					# Break player out of until-loop when they hit towards 21
					puts "You have a score of 21 with: #{@player.hand.join(", ")}."
					break
				else
					if @player.hand_value > 21
						end_round("bust")
					else
						hit_or_stay
					end
				end
			end
		end

		def evaluate_hand_score(hand)
			# Determine if the hand contains an Ace
			# If so, remove it from the array, and .push it to the last place
			# This way, Aces get evaluated last (11 or 1)
			y = 0        # indexing for the Ace-checking
			while y < @player.hand.length
				if @player.hand[y].include?("Ace")
					@player.hand.push(@player.hand.delete_at(y))
					y += 1
				else
					y += 1
				end
			end

			hand_score = 0
			x = 0       # indexing for the hand scoring, below
			while x < @player.hand.length
				if @player.hand[x].include?("Jack") || @player.hand[x].include?("Queen") || @player.hand[x].include?("King")
					hand_score += 10
					x += 1
				elsif @player.hand[x].include?("Ace")
					if (hand_score + 11) > 21
						hand_score += 1
					else
						hand_score += 11
					end 
					x += 1	
				elsif
					# Strip everything but the numbers from the string
					hand_score += @player.hand[x].gsub(/[^0-9]/, '').to_i
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

		# Save score as an integer in players_score
		players_score = evaluate_hand_score(@player.hand)
		# Determine if the player's hand is a blackjack
		player_has_blackjack = is_blackjack(@player.hand)

		# Until the value of dealers_hand > 15, they hit
		until evaluate_hand_score(dealers_hand) > 15
			dealers_hand.push(shuffled_deck[deck_index])
			puts "The dealer adds a #{shuffled_deck[deck_index]} to their hand."
			deck_index += 1
		end
		dealers_score = evaluate_hand_score(dealers_hand)
		# The dealer busts if over 21
		if dealers_score > 21
			puts "The dealer busts with #{dealers_score}."
			round_result("win", player_credits, player_bid, dealers_hand)
		end
		dealer_has_blackjack = is_blackjack(dealers_hand)

		# Final scoring
		# First, does anyone have a Blackjack?
		if player_has_blackjack == true || dealer_has_blackjack == true
			if player_has_blackjack == true && dealer_has_blackjack == false
				puts "Your Blackjack trumps the dealer."
				round_result("win", player_credits, player_bid, dealers_hand)
			elsif player_has_blackjack == false && dealer_has_blackjack == true
				puts "The dealer's Blackjack trumps your hand."
				round_result("lose", player_credits, player_bid, dealers_hand)
			elsif player_has_blackjack == true && dealer_has_blackjack == true
				puts "Both you and the dealer have a Blackjack."
				round_result("tie", player_credits, player_bid, dealers_hand)
			end

		# Second, if no Blackjacks are in anyone's hand:
		elsif players_score > dealers_score
			puts "Your #{players_score} whomps the dealer's meager #{dealers_score}."
			round_result("win", player_credits, player_bid, dealers_hand)
		elsif dealers_score > players_score
			puts "The dealer's #{dealers_score} eats your #{players_score} for breakfast."
			round_result("lose", player_credits, player_bid, dealers_hand)
		else
			round_result("tie", player_credits, player_bid, dealers_hand)
		end
	end
end
# ^ This end ends the Blackjack class

Blackjack
