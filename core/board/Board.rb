require_relative 'AbstractBoard'
require_relative 'Mark'

# A concrete implementation of the AbstractBoard. This implementation uses a
# standard Ruby array to store its subboards. Its initializer allows for a
# block to determine each subboard, but it provides convenient ways to
# initialize a Board in a 'standard' shape.
# @author Dylan Frese
class Board
    include AbstractBoard

    # @return [Integer] the width of the board.
    attr_reader :width

    # @return [Integer] the height of the board.
    attr_reader :height

    # Creates a new Board. By default, a square board with one level of
    # recursion is created. The depth of recursion is specified by the levels
    # argument, and works by filling the grid of subboards with new Boards with
    # the same width and height as this one, but one less layer of recursion.
    #
    # The recursion ends when the levels argument is equal to zero, in which
    # case the array is filled with Mark::BLANK instead of other boards.
    #
    # Note that the width and height do not specify the size in number of
    # spaces (Marks), but the number of subboards.
    #
    # If a block is passed in, the block is yielded to for every index in the
    # subboards array, and the result assigned to that index. In this case, the
    # levels argument has no meaning. It is possible to create irregular or
    # uneven boards this way.
    #
    # @raise [ArgumentError] if the width or height is not positive
    # @raise [ArgumentError] if levels is defined when a block is given
    # @raise [ArgumentError] if levels is negative
    # @param [Integer] width the width of the board. By default, this is 3.
    # @param [Integer] height the height of the board. By default, this is the
    #   same as the width.
    # @param [Integer] levels the number of levels of recursion. If nil, it is
    #   assumed to be 1, meaning a regular Board that is 9x9 Marks will be
    #   created.
    def initialize(width=3, height=width, levels=nil)
        if width <= 0 || height <= 0
            raise ArgumentError.new("Size must be positive.")
        end
        if block_given? && levels
            raise ArgumentError.new("Specifying levels has no meaning when a"\
                                    "block is given.")
        end

        levels ||= 1
        if levels < 0
            raise ArgumentError.new("Levels must be positive.")
        end

        @width = width
        @height = height
        @winner = nil

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

    # Retrieve a certain subboard, specified by the index or indices given.
    # @param [Integer] x the index of the subboard. If y is nil, this is the
    #   index of the board from 0. If y is not nil, it is the x-index of the
    #   board.
    # @param [Integer] y the y-index of the subboard. May be nil.
    # @return [AbstractBoard,Mark] the subboard at the specified location.
    # @example
    #   Suppose you have a 3x3 Board.
    #   To access the various subboards you could use the following:
    #
    #     x:            x,y:
    #   0 1 2       0,0 1,0 2,0
    #   3 4 5       0,1 1,1 2,1
    #   6 7 8       0,2 1,2 2,2
    def [](x, y=nil)
        if y
            @subboards[x + y * width]
        else
            @subboards[x]
        end
    end

    # Convenience method to change an unknown number of parameters into an
    # index, value pair. If there are two non-nil parameters: x, y; the index
    # is x and the value is y. If there are three: x, y, z; the index is
    # x + y * width, and the value is z. If the value is nil, it is assumed
    # to be Mark::BLANK.
    # @param x the first parameter
    # @param y the second parameter
    # @param z the third parameter
    # @return [Array] an index, value pair.
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
    
    # Checks that a subboard at the specified index can be set to the specified
    # value. Since subboards which are not Marks are immutable, and no subboard
    # can be set (after initialization) to something other than a Mark, these
    # are checked.
    # @raise [TypeError] if value is not a Mark
    # @raise [ArgumentError] if the index is out of bounds
    # @raise [ArgumentError] if the subboard at the specified index is not of
    #   type Mark.
    # @param [Integer] index the index of the subboard that is being set
    # @param [Mark, Object] value the value to check against.
    # @return [void]
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
    
    # Sets the subboard at the specified index to a value. The subboard to be
    # changed and the new value must both be of type Mark. This method can
    # accept either two or three parameters, similar to Board#[], where the
    # last parameter is the value.
    # @param x the first parameter
    # @param y the second parameter
    # @param z the third parameter
    # @return [void]
    def []=(x, y, z = nil)
        index, value = coerce(x, y, z)
        set_check(index, value)
        @subboards[index] = value
    end

    # Identical to Board#[]=, except the subboard is only changed if it was
    # blank.
    # @param x the first parameter
    # @param y the second parameter
    # @param z the third parameter
    # @return [void]
    def fill(x, y, z = nil)
        index, value = coerce(x, y, z)
        set_check(index, value)
        if @subboards[index].blank?
            @subboards[index] = value
        end
    end

    # Returns an Enumerator of all subboards, or, if a block is given, passes
    # that block to that Enumerator.
    # @return [void, Enumerator] the Enumerator, or nil if a block was given
    def each
        if block_given?
            @subboards.each(&proc)
            return nil
        else
            @subboards.each
        end
    end

    # Determines whether the board is 'full' or not. A board is full when all
    # of its subboards are non-blank Marks or other boards which are full. This
    # is a recursive method.
    # @return [Boolean] whether or not this board is full.
    def full?
        @subboards.all? {|board| board.full?}
    end

    # @return [String] a string representation of this board.
    def to_s
        @subboards.to_s
    end
end
