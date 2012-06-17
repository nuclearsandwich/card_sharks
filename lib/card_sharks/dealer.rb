class Dealer
  def initialize
    @hand = []
  end

  def deal(card)
    @hand << card
  end

  def tell_hand
    @hand
  end
end
