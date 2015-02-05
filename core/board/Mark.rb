require_relative 'AbstractBoard'

class Mark
    include AbstractBoard

    def initialize(string)
        @string = string
        @winner = value
    end

    BLANK = Mark.new(".")

    def width
        1
    end

    def height
        1
    end

    def [](x, y=nil)
        self
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

end
