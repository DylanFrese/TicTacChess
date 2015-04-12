require_relative 'AbstractBoard'

# This represents one mark on a board. A mark can be represented by any
# character. Formally, a Mark is an AbstractBoard that holds no subboards,
# and thus has no depth. Marks are typically assigned to players, who may place
# them on board spaces, but this class is agnostic to how it's used.
# @author Dylan Frese
class Mark
    include AbstractBoard

    # Creates a new Mark from the specified string. The character of the
    # resulting Mark is the first character in the string, and for clarity, the
    # passed in string should be one character.
    # @param [String] string the character to use to represent this Mark.
    def initialize(string)
        @string = string.chr
        @winner = value
    end

    # A Mark that represents an empty space.
    BLANK = Mark.new(".")

    # Returns 0, as a Mark has no subboards, and no width.
    # @return [Integer] 0
    def width
        0
    end

    # Returns 0, as a Mark has no subboards, and no height.
    # @return [Integer] 0
    def height
        0
    end

    # This method raises a TypeError always, since a Mark has no subboards and
    # the index is always out of bounds.
    # @raise TypeError always
    # @return [void]
    def [](x, y=nil)
        raise TypeError.new("A Mark has no subboards.")
    end

    # Returns nil if the Mark in question is Mark::BLANK, otherwise, returns
    # self.
    # @return [Mark] nil if the Mark is Mark::BLANK, self otherwise.
    def value
        self == BLANK ? nil : self
    end

    # @return [Boolean] true if the Mark is not equal to Mark::BLANK, false
    #   otherwise.
    def full?
        self != BLANK
    end

    # The string representation of this Mark. Equivalent to Mark#chr.
    # @return [String] the string representation of this Mark
    def to_s
        @string
    end

    # @return [Boolean] whether this Mark is equal to Mark::BLANK.
    def blank?
        self == BLANK
    end
    
    # The string representation of this Mark.
    # @return [String] the string representation of this Mark
    def chr
        @string
    end

    # Returns 0, as a Mark has no subboards.
    # @return [Integer] 0
    def depth
        0
    end

end
