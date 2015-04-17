require_relative 'Game'
require_relative '../event/InvalidMoveError'

class StandardGame < Game

    def initialize(players=2, width=3, height=3)
        super(players, Board.new(width, height))
        @current_board = nil
    end

    def current_board
        @current_board
    end

    def move(move)
        subboard = board.drill(move.location)
        if current_board && subboard != current_board
            errormsg = "Move must be on the current board."
            raise InvalidMoveError.new(move), errormsg
        end
        @current_board = subboard
        super(move)
    end
end
