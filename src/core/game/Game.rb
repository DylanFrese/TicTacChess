require_relative '../board/Board'
require_relative '../board/Mark'
require_relative 'Player'

class Game

    def initialize(players=2, board=Board.new)
        @board = board
        @players = players_to_a players
        @current_player = 0
        @moves = Array.new
    end

    def numplayers
        players.size
    end

    def players
        @players.dup
    end

    def current_player
        @players[@current_player]
        nil
    end

    def next_player
        @current_player += 1
        @current_player = 0 if @current_player == @players.size
        nil
    end

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

    def players_to_a(players)
        if players.is_a? Integer
            return Player.generate(players)
        elsif players.is_a? Array
            if players[0].is_a? Player
                return players.dup
            elsif players[0].is_a? Mark or players[0].is_a? String
                return Player.generate(players)
            end
        end
    end
            
    def valid?(move)
        if player >= @current_players.size
            raise "#{move.player.name} is not the current player!"
        end
        atom = move.atom
        if !atom.root.equal? @board
            raise "Move does not correspond to the current board!"
        end
        if move.location >= atom.spaces
            raise "Move is invalid!"
        end
    end
    private :valid?

    def board
        @board
    end

    def move(move)
        valid? move
        @board[move.location] = move.player.mark
        @moves << move
        next_player
    end

    def undo(num=1)
        raise "Nothing to undo!" if @moves.empty?
        raise "Cannot undo #{num} times!" if @moves.size < num
        @moves.pop! num
        initialize(@players)
        @moves.each {|move| move(move)}
    end
end
