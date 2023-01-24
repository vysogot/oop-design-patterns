# PL: Napisz program, który będzie symulował mecz piłki nożnej pomiędzy dwoma drużynami. Program powinien wykorzystywać różne strategie gry drużyn - jedna drużyna powinna grać ofensywnie, druga defensywnie. Drużyny powinny mieć możliwość zmiany swojej strategii w trakcie meczu. Program powinien przedstawiać statystyki meczu, takie jak liczba strzelonych bramek, liczba fauli itp.
# EN: Write a program that simulates a football match between two teams. The program should use different team strategies - one team should play offensively, the other defensively. Teams should be able to change their strategy mid-match. The program should show the statistics of the match, such as the number of goals scored, the number of fouls, etc.

class SoccerGame
  HALFS, MINUTES = 2, 45
  GOAL_P, FAUL_P = 20, 17
  
  attr_reader   :team_one, :team_two, :goals, :fauls
  attr_accessor :current_half, :current_minute
  
  def initialize(team_one, team_two)
    @team_one = team_one
    @team_two = team_two
    @goals = { team_one => 0, team_two => 0 }
    @fauls = { team_one => 0, team_two => 0 }
  end

  def play
    puts intro
    
    HALFS.times do |half|
      overtime = 0
      self.current_half = half + 1
      
      (MINUTES + overtime).round.times do |minute|
        self.current_minute = minute
        
        puts goal_shout if check_goals!
        overtime += 0.5 if check_fauls!
        check_strategies!
      end
      
      puts stats
    end
  end

  def check_goals!
    side = rand(GOAL_P)
    return unless [1, 2].include?(side)
    
    return add_goal(team_one) if side == 1 && team_one.attack > team_two.defense
    return add_goal(team_two) if side == 2 && team_two.attack > team_one.defense
  end
  
  def check_fauls!
    side = rand(FAUL_P)
    return if side == 0 
    
    return add_faul(team_one) if side == 1
    return add_faul(team_two) if side == 2
  end

  def check_strategies!
    team_one.check_strategy!(team_two, goals)
    team_two.check_strategy!(team_one, goals)
  end

  def add_faul(team)
    fauls[team] += 1 
  end
  
  def add_goal(team)
    goals[team] += 1 
  end

  def intro
    "Witamy Państwa na spotkaniu pomiędzy drużynami #{team_one.name} i #{team_two.name}\n" +
    "---\n"
  end

  def goal_shout
    "Gol w #{current_minute} minucie #{current_half} połowy! #{scores}\n"
  end
  
  def stats
    "#{half_finished}\n#{scores}\n#{fauls_rate}\n"
  end

  def scores
    "Wynik:\n#{team_one.name} #{goals[team_one]}:#{goals[team_two]} #{team_two.name}\n"
  end

  def fauls_rate
    "Faule:\n#{team_one.name} #{fauls[team_one]}:#{fauls[team_two]} #{team_two.name}\n"
  end

  def half_finished
    "Zakończono #{current_half} połowę w #{current_minute} minut(y)\n"
  end
end

class Team
  attr_reader :name, :game_strategy, :strategy_logic
  
  def initialize(name, game_strategy, strategy_logic)
    @name = name
    @game_strategy = game_strategy
    @strategy_logic = strategy_logic
  end

  def attack
    game_strategy.attack
  end
  
  def defense 
    game_strategy.defense
  end

  def check_strategy!(opponent, goals)
    new_strategy = strategy_logic.call(self, opponent, goals)
    return if new_strategy.class.name == game_strategy.class.name
    
    puts strategy_change_info(new_strategy)
    @game_strategy = new_strategy
  end

  def strategy_change_info(new_strategy)
    "---\nZMIANA! #{name} nowa strategia: #{new_strategy.name}\n---\n\n"
  end
end

class OffensiveStrategy
  def attack
    rand(5..10)
  end

  def defense
    rand(2..8)
  end

  def name
    "ofensywa"
  end
end

class DefensiveStrategy
  def attack
    rand(2..8)
  end

  def defense
    rand(5..10)
  end

  def name
    "defensywa"
  end
end

team1 = Team.new("Lech Poznań", OffensiveStrategy.new, -> (our_team, opp_team, goals) { 
  goals[our_team] - 1 > goals[opp_team] ? DefensiveStrategy.new : OffensiveStrategy.new
})

team2 = Team.new("Legia Warszawa", DefensiveStrategy.new, -> (our_team, opp_team, goals) {
  goals[our_team] < goals[opp_team] ? OffensiveStrategy.new : DefensiveStrategy.new
})
sg = SoccerGame.new(team1, team2)

sg.play