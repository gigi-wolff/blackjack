require 'pry'
SUITS = ['Hearts', 'Spades', 'Clubs','Diamonds']
CARDS = ['2','3','4','5','6','7','8','9','10','Jack','Queen','King','Ace']
FACE_CARD = ['Jack','Queen','King','Ace']

def hand_total(hand)
  total = 0
  hand.each do |card|
    if FACE_CARD.include?(card[0]) #is this a face card?
      if card[0]=='Ace'
        total += 11
      else
        total += 10
      end
    else
      total += card[0].to_i
    end
  end
  # Set value of Ace in hand to 1 if previous value of 11 causes bust
  total -=10 if (total>21 && hand.flatten.include?('Ace'))
  total
end

def display_hand(hand)
  current_hand = ""
  hand.each {|card| current_hand += "|#{card[0]} of #{card[1]}|  "}
  current_hand
end

def get_input
  begin
    puts "(H)it or (S)tay"
    answer = gets.chomp.downcase
  end until (answer=='h' || answer=='s') 
  answer 
end
#------------------- Main -------------------
deck = CARDS.product(SUITS)


#deck.shuffle!.each_index {|i| puts "#{i} #{deck[i-1]}"  }
# shuffle the deck
deck.shuffle!

# initialze hands and total value of each hand
player_hand = []
dealer_hand = []
dealer_total = 0
player_total = 0

# deal player's hand until he 'stays', reaches 21 or busts
begin
  # deal player a card
  player_hand << deck.pop

  #  find total value of hand
  player_total = hand_total(player_hand)

  # display hand and total
  puts "Your Hand: "+ display_hand(player_hand)
  puts "    TOTAL: " + player_total.to_s

  # if player busts, quit program
  if (player_total > 21) then
    puts "Busted! Dealer wins."
    puts "Game Over"
    exit
  elsif (player_total == 21) #blackjack, no more cards needed
    break
  else # ask if player wants another card
    response = get_input
  end
end until (response=='s')


# deal computer's a card until he reaches 17 or busts
begin
  # deal a card to dealer
  dealer_hand << deck.pop

  # find total value of hand
  dealer_total = hand_total(dealer_hand)

  #display hand and total
  puts "Dealer's Hand: "+display_hand(dealer_hand)
  puts "        TOTAL: " + dealer_total.to_s

  #if dealer busted display message and quit program
  if (dealer_total > 21) then
    puts "Dealer busted. You Win!"
    puts "Game Over"
    exit
  elsif dealer_total==21 #blackjack, break out
    break
  end
end until (dealer_total>=17)

# if neither dealer nor player has busted, whomever is closest to 21 wins
if (dealer_total > player_total)
  puts "Dealer wins."
elsif (dealer_total == player_total)
  puts "Its a tie. Dealer wins."
else
  puts "You Win!"
end
