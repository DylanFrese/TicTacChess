require_relative 'Game'
require_relative 'InvalidMoveError'

class StandardGame < Game

    def initialize(players=2, width=3, height=3)
        super(players, Board.new(width, height))
        @current_board = nil
    end

    def current_board
        @current_board
    end

    def move(move)
        subboard = find_subboard(move.atom)
        if current_board && subboard != current_board
            errormsg = "Move must be on the current board."
            raise InvalidMoveError.new(move), errormsg
        end
        @current_board = subboard
        super(move)
    end

    def find_subboard(board)
        subboard = board
        loop do
            parent = subboard.parent
            if !parent
                raise ArgumentError, "Board #{board} is not contained within "\
                                     "this game."
            end
            return subboard if parent == board
            subboard = parent
        end
    end
end
