require_relative 'AbstractBoard'

class Mark
    include AbstractBoard

    def initialize(string)
        @string = string.chr
        @winner = value
    end

    BLANK = Mark.new(".")

    def width
        0
    end

    def height
        0
    end

    def [](x, y=nil)
        raise TypeError.new("A Mark has no subboards.")
    end

    def value
        self == BLANK ? nil : self
    end

    def full?
        self != BLANK
    end

    def to_s
        @string
    end

    def blank?
        self == BLANK
    end
    
    def chr
        @string
    end

    def depth
        0
    end

end
