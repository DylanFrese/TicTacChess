require_relative 'Event'

# This class represents a move made, or to be made on a certain board.
# Formally, this encapsulates a request to set a Mark at a certain location on
# the specified board to the Mark of the given player.
# @author Dylan Frese
class Move < Event

    # @return [Array<Integer>] the board on which this Move is to be made
    attr_reader :board
    # @return [Player] the player making the move
    attr_reader :player
    # @return [Integer] the 0-based index of the Mark to be changed
    attr_reader :location

    # Initialize a new Move with a loaction, player, and board. The location is
    # the index of the Mark which is to be changed. The board is the board
    # of which the Mark is a subboard, or, more simply, the board on which the
    # move is made. It is specified in the same way as AbstractBoard#drill,
    # that is to say, root.drill(board) is the subboard, where root is the root
    # board.
    # 
    # As of now, no input validation is done, and this class is a simple
    # container.
    # @param [Integer] location the 0-based index of the Mark which is to be
    #   changed
    # @param [Array<Integer>] board the board on which the move is made
    # @param [Player] player the player making the move
    def initialize(location, board, player)
        super(:GAME_MOVE, 1)

        @board = board
        @location = location
        @player = player
    end
end
