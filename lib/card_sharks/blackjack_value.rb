class BlackjackValue
  def initialize(hand)
    @hand = hand
  end

  def values
    {"Two" => 2, "Three" => 3, "Four" => 4, "Five" => 5, "Six" => 6,
    "Seven" => 7, "Eight" => 8, "Nine" => 9, "Ten" => 10, "Jack" => 10,
    "Queen" => 10, "King" => 10, "Ace" => 11}
  end

  def value
    @hand.reduce(0) do |sum_of_values, card|
      sum_of_values + values[card.rank]
    end
  end
end
