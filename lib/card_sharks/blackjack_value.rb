class BlackjackValue
  def initialize(hand)
    @hand = hand
  end

  def values
    {"Two" => 2, "Three" => 3, "Four" => 4, "Five" => 5, "Six" => 6,
    "Seven" => 7, "Eight" => 8, "Nine" => 9, "Ten" => 10, "Jack" => 10,
    "Queen" => 10, "King" => 10, "Ace" => 11}
  end

  # look into:
  # Enumerable#any?
  # or...
  # Enumerable#count
  # for solving for Aces

  def value
    @hand.reduce(0) do |sum_of_values, card|
      sum_of_values + values[card.rank]
    # if sum_of_values > 21 && @hand.any? { |card| card.include?("Ace") }
    #   sum_of_values -= 10
    # end
    end
  end
end
