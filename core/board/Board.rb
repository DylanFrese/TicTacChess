require_relative 'AbstractBoard'

class Board
    include AbstractBoard

    attr_reader :width, :height

    def initialize(width=3, height=3, levels=1)
        @width = width
        @height = height
        @winner = nil
        if block_given?
            @subboards = Array.new(width * height) {proc[self]}
        else
            if levels > 1
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

    def each
        return @subboards.each &proc if block_given?
        @subboards.each
    end

    def full?
        @subboards.all? {|board| board.full?}
    end

    def to_s
        @subboards.to_s
    end
end

require_relative 'AtomBoard'
