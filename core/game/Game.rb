require_relative '../board/Board'
require_relative '../board/Mark'

class Game
    attr_reader :players, :current_player

    @moves = Array.new

    def initialize(players=2, board=Board.new)
        @board = board
        @players = players_to_a players
        @player_enum = @players.cycle
        next_player
    end

    def numplayers
        players.size
    end

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
        raise "#{move.player.name} is not the current player!" if @current_player != move.player
        atom = move.atom
        raise "Move does not correspond to the current board!" if !atom.root.equal? @board
        raise "Move is invalid!" if move.location >= atom.spaces
    end
    private :valid?

    def next_player
        @current_player = @player_enum.next
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
