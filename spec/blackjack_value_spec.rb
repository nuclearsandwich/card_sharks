require "card_sharks/card"
require "card_sharks/blackjack_value"

describe BlackjackValue do
  let(:hand) { [] }

  it "calculates the value of an empty hand as 0." do
    hand_value = BlackjackValue.new(hand).value
    hand_value.should == 0
  end

  it "calcuates the value of a single card." do
    hand << Card.new("Hearts", "Three")
    hand_value = BlackjackValue.new(hand).value
    hand_value.should == 3
  end

  it "calcuates the value of a hand that busts." do
    hand << Card.new("Clubs", "Queen")
    hand << Card.new("Hearts", "Seven")
    hand << Card.new("Clubs", "Eight")
    hand_value = BlackjackValue.new(hand).value
    hand_value.should == 25
  end

  it "tests soft Aces (11)." do
    hand << Card.new("Hearts", "Ten")
    hand << Card.new("Clubs", "Ace")
    hand_value = BlackjackValue.new(hand).value
    hand_value.should == 21
  end

  it "tests hard Aces (1)." do
    #pending "Not yet implemented."
    hand << Card.new("Hearts", "Ten")
    hand << Card.new("Hearts", "Eight")
    hand << Card.new("Clubs", "Ace")
    hand_value = BlackjackValue.new(hand).value
    hand_value.should == 19
  end
end
