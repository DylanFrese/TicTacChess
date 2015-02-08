require_relative 'AbstractBoard'

class Board
    include AbstractBoard

    attr_reader :width, :height

    def initialize(width=3, height=3, levels=1)
        raise ArgumentError.new("Size must be positive") if width <= 0 || height <= 0
        raise ArgumentError.new("Levels must be positive") if levels < 0
        @width = width
        @height = height
        @winner = nil
        if block_given?
            @subboards = Array.new(width * height) {|i| proc[i]}
        else
            if levels > 0
                @subboards = Array.new(width * height) {Board.new(width, height, levels - 1)}
            else
                @subboards = Array.new(width * height) {Mark::BLANK}
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

    def coerce(x, y, z=nil)
        if z
            index = x + y * width
            value = z
        else
            index = x
            value = y
        end
        return [index, value]
    end
    
    def set_check(index, value)
        raise TypeError.new("#{value} is not a type of Mark!") unless value.is_a? Mark
        raise ArgumentError.new("Index #{index} is out of bounds!") if index >= @subboards.length
        raise ArgumentError.new("The subboard at index #{index} is not of type Mark, and is immutable.") unless @subboards[index].is_a? Mark
    end

    private :coerce
    
    def []=(x, y, z = nil)
        index, value = coerce(x, y, z)
        if value == nil
            value = Mark::BLANK
        end
        set_check(index, value)
        @subboards[index] = value
    end

    def fill(x, y, z = nil)
        index, value = coerce(x, y, z)
        if value == nil
            value = Mark::BLANK
        end
        set_check(index, value)
        if @subboards[index].blank?
            @subboards[index] = value
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
