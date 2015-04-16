require_relative 'Event'

class NewGameEvent < Event

    attr_reader :game
    
    def initialize(game)
        super(:GAME_NEW_GAME, 2)
        @game = game
    end
end
