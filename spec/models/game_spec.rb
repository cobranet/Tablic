require 'rails_helper'

arr = [2, 41, 33, 19, 21, 47, 
       24, 36, 37, 27, 5, 0, 
       31, 1, 40, 8, 35, 10, 
       7, 25, 17, 51, 18, 48, 
       44, 42, 45, 4, 
       6, 32, 11, 15, 30, 20, 12, 14, 22, 34, 9, 49, 38, 23, 39, 13, 28, 50, 3, 43, 29, 46, 16, 26]


# At move 1
# NORTH : ["2S", "2C", "7H", "6D", "8D", "8C"]
# EAST : ["JD", "10H", "JH", "AH", "5S", "KC"]
# SOUTH : ["5H", "AS", "AC", "8S", "9H", "10S"]
# WEST  ["7S", "QD", "4D", "QC", "5D", "9C"]
# TABLE  ["5C", "3C", "6C", "4S"]


RSpec.describe Game, :type => :model do

  it "can get array as param" do
    g = Game.new(4,arr) 
    g.deal
    state = g.state 
    expect(state[:talon].size).to eq(4)
    expect(state[:hands].size).to eq(g.num_of_players)
    state[:hands].each do |hand|
      expect(hand.size).to eq(6)
    end
  end
  
  
  it "there is ai function which return all posible sums from array to first param" do
    AI.find_take(7,[4,3,4,3]).each do |x| 
      expect ([[2,3],[0,3],[0,1],[2,1]].include?(x))
    end

    AI.find_take(8,[4,3,4,3]).each do |x| 
      expect ([[0,2]].include?(x))
    end

    AI.find_take(12,[4,4,4,3]).each do |x| 
      expect ([[0,1,2]].include?(x))
    end

    AI.find_take(10,[4,4,4,3]).each do |x| 
      expect ([[]].include?(x))
    end
    
    AI.find_take(7,[7,1]).each do |x|
      expect([[7]].include?(x))
    end
    expect(AI.find_take(10,[4,2,4,6]).size).to eq(3)
    AI.find_take(10,[4,2,4,6]).each do |x| 
      expect ([[0,3],[0,1,2],[2,3]].include?(x))
    end
    expect(AI.find_take(1,[6,5,1,10]).size).to eq(3)
    AI.find_take(1,[6,5,1,10]).each do |x| 
      expect ([[1],[6,5],[10,1]].include?(x))
    end

    
  end
  
  it "can return what to take from talon" do
    g = Game.new(4,arr)
    g.deal
    expect(g.find_take(Card.ids("9C"))).to eq([[Card.ids("4C"),Card.ids("5S")]])
    expect(g.find_take(Card.ids("7D"))).to eq([[Card.ids("7C")]])
  end
  
  it "when player play a card must reduce players hand " do
    g = Game.new(4,arr)
    g.deal
    g.make_play(Card.ids("7D"))
    expect(g.state[:hands][0].size).to eq(5)
    expect(g.state[:talon].size).to eq(5)
    expect(g.on_move).to eq(1)
  end

  it "when player play take a trick his taken stack be increased " do
    g = Game.new(4,arr)
    g.deal
    g.make_play(Card.ids("3S"))
    a = g.find_take(Card.ids("JH"))[0]
    g.make_play(Card.ids("JH"),a)
    expect(g.state[:hands][0].size).to eq(5)
  end
  
  it "sum of all score cards must be 22" do
    score = 0
    Game.testArray.each do |card|
      score = Game.score_value(card) + score
    end
    expect(score).to eq(22)
  end

  it "has score function that return score for every player" do
    g = Game.new(4,arr) 
    g.deal
    g.num_of_players.times do |player|
      expect(g.score(player)).to eq(0) 
    end
    g.make_play(Card.ids("3S"))
    g.make_play(Card.ids("JH"),g.find_take(Card.ids("JH"))[0])
    expect(g.score(1)).to eq(1) 
  end 
end
