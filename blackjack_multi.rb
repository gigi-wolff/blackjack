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
  return total
end

def display_hand(hand)
  current_hand = ""
  hand.each {|card| current_hand += "|#{card[0]} of #{card[1]}|  "}
  return current_hand
end   

def get_input(name)
  begin
    puts name + ", do you want to (H)it or (S)tay?"
    answer = gets.chomp.downcase  
  end until (answer=='h' || answer=='s')
  return answer
end

def play_a_hand(name,deck)
  player_hand = []
  player_total = 0
  # deal player's hand until he 'stays', reaches 21 or busts
  while (player_total<21)
    # deal player a card
    player_hand << deck.pop 

    #  find total value of hand
    player_total = hand_total(player_hand)

    # display hand and total
    puts name + "'s Hand: "+ display_hand(player_hand) 
    puts "    TOTAL: " + player_total.to_s

    # ask if player wants another card if hand is less than 21
    if player_total<21
      player_response = get_input(name)
      break if player_response=='s'
    end
  end
  return player_total
end

def get_players
  players_hands = {} 
  puts "Welcome to 4-deck Blackjack. How many people want to play?"
  num_of_players = gets.chomp
  num_players = num_of_players.to_i

  num_players.times do |num|
    puts "Please enter name of #{num+1}:"
    name = gets.chomp
    players_hands[name] = 0
  end
  return players_hands
end

#------------------- Main -------------------
#initializatons
player = {} #player = {name => hand value}
deck = CARDS.product(SUITS)
deck = (deck + deck + deck + deck).shuffle! #play with four decks
dealer_hand = []
dealer_total = 0

#players in the game
player = get_players

player.each {|name,v| puts "Welcome #{name}!"}

# play a hand for each player in the hand
player.each do |name,hand_value|  
  player[name] = play_a_hand(name,deck)

  # Display messages, remove player from game if busted
  if (player[name] > 21) then
    puts "Busted!"
    player.delete(name) # player is out of bame
  elsif (player[name] == 21) #blackjack, no more cards needed
     puts "Blackjack!"
  end
end

#Quit game if no players are left
exit if player.empty?

# deal computer's a card until he reaches 17 or busts
while (dealer_total < 17)
    # deal a card to dealer 
    dealer_hand << deck.pop
    
    # find total value of hand
    dealer_total = hand_total(dealer_hand)

    #display hand and total
    puts "Dealer's Hand: "+display_hand(dealer_hand)
    puts "        TOTAL: " + dealer_total.to_s  
end

# Display messages, end game if dealer busted
if (dealer_total > 21) then
  puts "Dealer busted. " + name + " Wins! Game Over."    
  exit
elsif (dealer_total==21) #blackjack, break out 
  puts "Blackjack! Dealer wins."
  exit       
end

# if neither dealer nor player has busted, whomever is closest to 21 wins
player.each do |name,hand_total|
  if (dealer_total > hand_total)
    puts "Dealer wins."
  else
   puts name + " wins!"
  end
end

