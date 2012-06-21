class Card < Struct.new(:suit, :rank, :value)
  VALUES = %w[2 3 4 5 6 7 8 9 10 10 10 10 0]
  RANKS = %w[Two Three Four Five Six Seven Eight Nine Ten Jack Queen King Ace]
  SUITS = %w[Clubs Diamonds Hearts Spades]

  def inspect
    to_s
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def self.ranks
    RANKS
  end

  def self.suits
    SUITS
  end

  def self.values
    VALUES
  end
end

# SIZE = 52
# deck = []

# SIZE.times do |i|
# rank = Card.ranks[i % 13]
# value = Card.values[i % 13]
# suit = Card.suits[i % 4]
# deck << Card.new(suit, rank, value)
# end

# puts deck[12].value
