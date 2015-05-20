require 'pry'

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'guessr/version'
require 'guessr/init_db'
require 'guessr/menu'

## Number Guessing Game
#* New Game
#* Existing Game

#* New Game
#* Ask them to choose player
#* Each turn, they can guess a number or quit

#* Existing Game
#* Each turn, they can guess a number or quit

module Guessr
  class Player < ActiveRecord::Base
    has_many :games
  end

  class Game < ActiveRecord::Base
    belongs_to :player

    def game_over?
      self.answer == self.last_guess
    end

    def play
      until self.game_over?
        puts "Please guess a number (or quit with 'q'): "
        result = gets.chomp
        if result == 'q'
          exit
        else
          self.turn(result)
        end
      end
    end

    def turn(guess)

      self.update(last_guess: guess.to_i,
                  guess_count: self.guess_count + 1)
      if self.last_guess > self.answer
        puts "Too high!"
      elsif self.last_guess < self.answer
        puts "Too low!"
      else
        puts "You win!"
        self.update(finished: true)
        # binding.pry
        current_score = self.player.score
        self.player.update(score: current_score + (100 - (10 * self.guess_count)))
        score = self.player.score
        puts score
        # binding.pry
        puts "Your score: #{score}"
      end
    end
  end
end


menu = Guessr::Menu.new
# binding.pry
menu.run
