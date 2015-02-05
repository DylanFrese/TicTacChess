class AtomBoard
    
    def initialize(width=3, height=3)
        @width = width
        @height = height
        @winner = nil
        @subboards = Array.new(width * height) { Mark::BLANK }
    end
    
    def coerce(x, y, z=nil)
        if z
            index = x + y * width
            value = z
        else
            index = x
            value = y
        end
        raise TypeError.new("#{value} is not a type of Mark!") unless value.is_a? Mark
        return [index, value]
    end
    private :coerce
    
    def []=(x, y, z = nil)
        index, value = coerce(x, y, z)
        @subboards[index] = value
        dirty = true
    end

    def fill(x, y, z = nil)
        index, value = coerce(x, y, z)
        if @subboards[index].blank?
            @subboards[index] = value
            dirty = true
        end
    end

    def to_s
        rows.map {|x| x.join(" ")}.join("\n")
    end
end

require_relative 'Board'
require_relative 'Mark'
