require "./Card"

class Deck
  SIZE = 52

  def initialize 
    @deck = []

    SIZE.times do |i|
      rank = Card.ranks[i % 13]
      suit = Card.suits[i % 4]

      @deck << Card.new(suit, rank)
    end
  end

  def tell_deck
    @deck.join(", ")
  end

  def sort!
    @deck.sort_by do |card|
      card.suit
    end
  end

  def shuffle!
    @deck.shuffle!
  end

  def remove_top_card
    @deck.delete_at(0)
  end
end

# This test appropriately creates a deck, populates it, shuffles it, and when calling remove_top_card,
# removes the very first card, adds it to waffles, and when printing out the deck again, the first
# card has, indeed, been removed...
# deck = Deck.new
# deck.shuffle!
# puts deck.tell_deck.join(", ")
# puts
# waffles = []
# puts waffles
# waffles.push(deck.remove_top_card)
# puts waffles
# puts
# puts deck.tell_deck.join(", ")
