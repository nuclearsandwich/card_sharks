class Player
  def initialize
    @credits = 150
    @hand = []
  end

  def credits
    @credits
  end

  def make_bid
    if @credits == 0
      puts "You are out of credits."
      exit 0
    end
    puts "How many of your #{@credits} credits would you like to wager?"
    bid = gets.chomp.to_i
    if (bid > 0 && bid <= @credits)
    else 
      make_bid
    end
  end

  def deal(card)
    @hand << card
  end
end
