# Napisz program, który będzie symulował rozgrywkę w ping-ponga. Program powinien pozwalać na przechowywanie informacji o wszystkich rozegranych meczach (np. data, liczba punktów zdobytych przez każdą ze stron). Następnie, program powinien umożliwić wyświetlenie historii wszystkich rozegranych meczów, pozwalając na przeglądanie ich po kolei (np. od najnowszego do najstarszego lub od najstarszego do najnowszego).

require 'date'

class PingPongGame
  attr_reader :date, :side_one, :side_two, :points
  attr_accessor :winner, :looser

  def initialize(date, side_one, side_two)
    @date = date
    @side_one = side_one
    @side_two = side_two
    @points = { side_one => 0, side_two => 0 }
    @winner, @looser = nil
  end

  def play
    until game_done? 
      side = rand(2)
      
      points[side_one] += 1 if side == 0
      points[side_two] += 1 if side == 1
    end

    finish_game
  end

  def game_done?
    points[side_one] == 21 && points[side_two] < 20 ||
      points[side_two] == 21 && points[side_one] < 20 ||
      (points[side_one] > 20 && points[side_two] > 20 && 
        (points[side_one] - points[side_two]).abs == 2)
  end

  def finish_game
    if points[side_one] > points[side_two] 
      self.winner = side_one 
      self.looser = side_two
    else
      self.winner = side_two
      self.looser = side_one
    end
  end

  def to_s
    "Gra z dnia #{date} pomiędzy #{side_one} i #{side_two}. Wynik: #{score}"
  end

  def score
    "#{winner} #{points[winner]}:#{points[looser]} #{looser}"
  end
end

class GameHistory
  attr_accessor :games 

  def initialize(games)
    @games = games
  end

  def add_game(game)
    games << game
  end

  def iterator(options = {})
    GamesIterator.new(games, options)
  end
end

class GamesIterator
  def initialize(games, options)
    @games = games   
    @index = 0
    @order = options[:order]
    
    sort(@order) if @order
  end

  def has_next?
    index < games.size     
  end

  def next_one
    games[index].tap do 
      self.index += 1
    end
  end

  def sort(direction)
    return games.sort! { |game| game.date } if direction == :asc
    return games.sort! { |x, y| y.date <=> x.date } if direction == :desc
  end

  private
  
  attr_reader :games
  attr_accessor :index
end

ppg1 = PingPongGame.new(Date.today, "John", "Janek")
ppg2 = PingPongGame.new(Date.today - 2, "John", "Janek")
ppg3 = PingPongGame.new(Date.today - 1, "John", "Janek")

games = [ppg1, ppg2, ppg3]
games.each { |game| game.play }

gh = GameHistory.new(games)
gi = gh.iterator(order: :desc)

while gi.has_next?
  puts gi.next_one
end


