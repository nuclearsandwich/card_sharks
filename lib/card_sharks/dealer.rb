class Dealer
  def initialize
    @hand = []
  end

  def deal(card)
    @hand << card
  end

  def hand
    @hand
  end

  def tell_hand
    @hand.join(", ")
  end
end
