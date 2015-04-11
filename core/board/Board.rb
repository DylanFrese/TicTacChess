require_relative 'AbstractBoard'

class Board
    include AbstractBoard

    attr_reader :width, :height

    def initialize(width=3, height=width, levels=nil)
        if width <= 0 || height <= 0
            raise ArgumentError.new("Size must be positive.")
        end
        if block_given? && levels
            raise ArgumentError.new("Specifying levels has no meaning when a"\
                                    "block is given.")
        end
        if levels < 0
            raise ArgumentError.new("Levels must be positive.")
        end

        @width = width
        @height = height
        @winner = nil

        levels ||= 1
        if block_given?
            array_proc = proc
        else
            if levels > 0
                array_proc = Proc.new {Board.new(width, height, levels - 1)}
            else
                array_proc = Proc.new {Mark::BLANK}
            end
        end
        @subboards = Array.new(width * height) {|i| array_proc[i]}
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
        value ||= Mark::BLANK
        return [index, value]
    end
    
    def set_check(index, value)
        if !value.is_a? Mark
            raise TypeError.new("#{value} is not a type of Mark!")
        end
        if index >= @subboards.length
            raise ArgumentError.new("Index #{index} is out of bounds!")
        end
        if !@subboards[index].is_a? Mark
            raise ArgumentError.new("The subboard at index #{index}"\
                                    " is not of type Mark, and is immutable.")
        end
    end

    private :coerce
    
    def []=(x, y, z = nil)
        index, value = coerce(x, y, z)
        set_check(index, value)
        @subboards[index] = value
    end

    def fill(x, y, z = nil)
        index, value = coerce(x, y, z)
        set_check(index, value)
        if @subboards[index].blank?
            @subboards[index] = value
        end
    end

    def each
        return @subboards.each(&proc) if block_given?
        @subboards.each
    end

    def full?
        @subboards.all? {|board| board.full?}
    end

    def to_s
        @subboards.to_s
    end
end
