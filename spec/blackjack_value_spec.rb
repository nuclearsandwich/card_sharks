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

  # tests with a single ace
  it "tests hard Aces (1) - does not bust, or == 21." do
    hand << Card.new("Hearts", "Ten")
    hand << Card.new("Hearts", "Eight")
    hand << Card.new("Clubs", "Ace")
    hand_value = BlackjackValue.new(hand).value
    hand_value.should == 19
  end

  # tests with a single ace, == 21
  it "tests hard Aces (1) - results in 21." do
    hand << Card.new("Hearts", "Ten")
    hand << Card.new("Spades", "Queen")
    hand << Card.new("Diamonds", "Ace")
    hand_value = BlackjackValue.new(hand).value
    hand_value.should == 21
  end

  # tests with a single ace, bust
  it "tests hard Aces (1) - but still a bust." do
    hand << Card.new("Hearts", "Ten")
    hand << Card.new("Spades", "Queen")
    hand << Card.new("Spades", "Two")
    hand << Card.new("Diamonds", "Ace")
    hand_value = BlackjackValue.new(hand).value
    hand_value.should == 23
  end

  # tests with two aces
  it "tests two Aces - only reduces one of the Aces." do
    hand << Card.new("Spades", "Ace")
    hand << Card.new("Hearts", "Ace")
    hand_value = BlackjackValue.new(hand).value
    hand_value.should == 12
  end

  # test with two aces
  it "tests two Aces - only reduces one, and == 21." do
    hand << Card.new("Hearts", "Ace")
    hand << Card.new("Spades", "Six")
    hand << Card.new("Spades", "Three")
    hand << Card.new("Clubs", "Ace")
    hand_value = BlackjackValue.new(hand).value
    hand_value.should == 21
  end
end
