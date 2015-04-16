# This class is an error used when some part of the game wants to indicate that
# a given Move was invalid for some reason.
# @author Dylan Frese
class InvalidMoveError < StandardError

    # @return [Move] the move that was invalid. May be nil.
    attr_reader :move

    # Create a new error. Optionally, a Move can be passed in to store what
    # Move was considered invalid.
    def initialize(move=nil)
        @move = move
        super()
    end

end
