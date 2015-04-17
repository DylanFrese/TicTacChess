require_relative '../board/Board'
require_relative '../board/Mark'
require_relative 'Player'
require_relative '../event/Move'
require_relative '../event/InvalidMoveError.rb'

# A Game, played on a board, by some Players, who make some Moves on that
# board. The board may be any AbstractBoard. This class handles mainting who
# the current player is, the current board, and a list of moves made. Methods
# are provided to undo moves, set the current player, and check if a move is
# valid. The default behaviours can be overriden by a subclass.
# @author Dylan Frese
class Game

    # Create a new Game.
    #
    # The players parameter can be an array of players, or any other type that
    # is accepted by Player::generate, such as a string of symbols, or array of
    # symbols.
    #
    # The board can be any AbstractBoard.
    # @raise [TypeError,ArgumentError] if players is invalid
    # @param [Integer,Array<Player,String>,String] players the players of the
    #   game
    # @param [AbstractBoard] board the board on which the game is played
    def initialize(players=2, board=Board.new)
        @board = board
        @players = players_to_a players
        @current_player = 0
        @moves = Array.new
    end

    # @return [Integer] the number of players in the game
    def numplayers
        players.size
    end

    # Creates a duplicate of the internal array of players.
    # @return [Array<Player>] the players of the game
    def players
        @players.dup
    end

    # @return [Player] the current player
    def current_player
        @players[@current_player]
    end

    # Increments the current player to the next player. This will loop around
    # once all players have been selected once.
    # @return [void]
    def next_player
        @current_player += 1
        @current_player = 0 if @current_player == @players.size
        nil
    end

    # Sets the current player to the specified parameter, which can be either
    # an index or Player object.
    # @raise [ArgumentError] if player is out of bounds, or represents a player
    #   that is not in this game
    # @raise [TypeError] if player is not an Integer or Player
    # @param [Player,Integer] player the player to set as the current player
    # @return [void]
    def set_current_player(player)
        if player.is_a? Player
            index = @players.index player
            raise ArgumentError, "Player '#{player}' "\
                                 "is not a player of this game." if !index
            @current_player = index
        elsif player.is_a? Integer
            if player >= @current_players.size
                raise ArgumentError, "Player index '#{player}' "\
                                     "is out of bounds!"
            end
            @current_player = player
        else
            raise TypeError, "Player is a #{player.class}, expected Player "\
                             "or Integer."
        end
    end

    alias :next :next_player

    # Gets an array of players from the parameter. This defers to
    # Player::generate if the parameter is not already an array of players.
    # @param [Integer,String,Array<Player,String>] players the parameter to
    #   coerce
    # @return [Array<Player>] the array of players
    def players_to_a(players)
        if players.is_a?(Array) && players[0].is_a?(Player)
            return players.dup
        else
            return Player.generate(players)
        end
    end

    # Checks if a move is valid, raising an InvalidMoveError if it's not. This
    # entails checking if the move is made by the current player, and in a
    # valid location (on a subboard that exists changing a Mark on that
    # subboard).
    # @raise [InvalidMoveError] if the move is invalid
    # @return [void]
    def valid?(move)
        if move.player != @players[@current_player]
            raise InvalidMoveError.new(move),
                "#{move.player.name} is not the current player!"
        end
        begin
            if !board.drill(move.location)[move.atom].is_a? Mark
                raise InvalidMoveError.new(move),
                    "#{move.location} is an invalid location! Moves must "\
                    "change only Marks."
            end
        rescue
            raise InvalidMoveError.new(move),
                "#{move.location} is an invalid location!"
        end
    end
    private :valid?

    # @return [AbstractBoard] the board on which the game is being played
    def board
        @board
    end

    # Make a move on the board, setting the mark at that move's location to
    # that of the player's. Then, advance to the next player.
    # @raise [InvalidMoveError] if the move is invalid
    # @return [void]
    def move(move)
        valid? move
        @board[move.location] = move.player.mark
        @moves << move
        next_player
    end

    # @return [Move] the last made move
    def last_move
        @moves.last
    end

    # Undo a number of moves, setting the board to a previous state.
    # @param [Integer] num the number of moves to undo
    # @return [void]
    def undo(num=1)
        raise "Nothing to undo!" if @moves.empty?
        raise "Cannot undo #{num} times!" if @moves.size < num
        @moves.pop! num
        initialize(@players)
        @moves.each {|move| move(move)}
    end
end
