require_relative 'Event'

class GameUpdate < Event

    attr_reader :game

    def initialize(game)
        super(:GAME_UPDATE, 5)
        @game = game
    end
end
