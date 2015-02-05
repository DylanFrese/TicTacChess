require_relative 'AbstractBoard'

class Board
    include AbstractBoard

    attr_reader :width, :height

    def initialize(width=3, height=3, levels=0)
        @width = width
        @height = height
        @winner = nil
        if block_given?
            @subboards = Array.new(width * height) {proc[self]}
        else
            if levels > 0
                @subboards = Array.new(width * height) {Board.new(width, height, levels - 1)}
            else
                @subboards = Array.new(width * height) {AtomBoard.new(width, height)}
            end
        end
        @subboards.each {|board| board.parent = self}
    end

    def [](x, y=nil)
        if y
            @subboards[x + y * width]
        else
            @subboards[x]
        end
    end

    def full?
        @subboards.all? {|board| board.full?}
    end

    def to_s
        @subboards
    end
end

require_relative 'AtomBoard'
