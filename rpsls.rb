require 'pry'

class Move
  attr_reader :value

  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def >(other_move)
    rock_win?(other_move) ||
      paper_win?(other_move) ||
      scissors_win?(other_move) ||
      lizard_win?(other_move) ||
      spock_win?(other_move)
  end

  def <(other_move)
    rock_lose?(other_move) ||
      paper_lose?(other_move) ||
      scissors_lose?(other_move) ||
      lizard_lose?(other_move) ||
      spock_lose?(other_move)
  end

  def scissors?
    value == 'scissors' ? true : false
  end

  def rock?
    value == 'rock' ? true : false
  end

  def paper?
    value == 'paper' ? true : false
  end

  def lizard?
    value == 'lizard' ? true : false
  end

  def spock?
    value == 'spock' ? true : false
  end

  # Win Conditions

  def rock_win?(other_move)
    rock? && (other_move.scissors? || other_move.lizard?)
  end

  def paper_win?(other_move)
    paper? && (other_move.rock? || other_move.spock?)
  end

  def scissors_win?(other_move)
    scissors? && (other_move.paper? || other_move.lizard?)
  end

  def lizard_win?(other_move)
    lizard? && (other_move.paper? || other_move.spock?)
  end

  def spock_win?(other_move)
    spock? && (other_move.rock? || other_move.scissors?)
  end

  # Lose Conditions

  def rock_lose?(other_move)
    rock? && (other_move.paper? || other_move.spock?)
  end

  def paper_lose?(other_move)
    paper? && (other_move.scissors? || other_move.lizard?)
  end

  def scissors_lose?(other_move)
    scissors? && (other_move.rock? || other_move.spock?)
  end

  def lizard_lose?(other_move)
    lizard? && (other_move.rock? || other_move.scissors?)
  end

  def spock_lose?(other_move)
    spock? && (other_move.paper? || other_move.lizard?)
  end
end

class Player
  attr_accessor :move, :name, :choice

  def initialize
    @choice = nil
    set_name
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    loop do
      puts 'Please choose rock, paper, scissors, lizard, or spock:'
      self.choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2'].sample
  end

  def choose
    if name == 'R2D2'
      r2d2
    else
      self.choice = Move::VALUES.sample
    end
    self.move = Move.new(choice)
  end

  # Personalities
  def r2d2
    roll = rand(1..100)
    case roll
    when 1..50
      self.choice = Move::VALUES[0]
    else
      self.choice = Move::VALUES[1, Move::VALUES.length - 1].sample
    end
  end
end

# RPS GAME ENGINE --------------------------------------------------------------

class RPSGame
  attr_accessor :human, :computer, :score, :game_history

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = Score.new
    @game_history = []
  end

  def add_history
    score.add(human, computer)
    game_history << { human.name => human.choice, computer.name => computer.choice, "winner" => return_winner }
  end

  def display_history
    game_history.each { |play| puts play }
    score.display(human, computer)
  end

  def display_moves
    puts "#{human.name} chose #{human.move.value}."
    puts "#{computer.name} chose #{computer.move.value}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end
    answer == 'y' ? true : false
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      add_history
      display_moves_winner_score
      (break unless play_again?) if score.winner_found?
    end
    display_history
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock!"
  end

  def return_winner
    if human.move > computer.move
      human.name
    elsif human.move < computer.move
      computer.name
    else
      "---"
    end
  end

  def display_moves_winner_score
    display_moves
    display_winner
    score.display(human, computer)
  end
end
# Score Class ---------------------------------------------------------------
class Score
  attr_accessor :computer_score, :human_score

  def initialize
    @human_score = 0
    @computer_score = 0
  end

  def add(human, computer)
    if human.move > computer.move
      self.human_score += 1
    elsif computer.move > human.move
      self.computer_score += 1
    end
  end

  def display(human, computer)
    puts "#{human.name}: #{human_score} || #{computer.name}: #{computer_score}"
  end

  def winner_found?
    true if human_score >= 3 || computer_score >= 3
  end
end
# ------------------------------------------------------------------------------

game = RPSGame.new
game.play
