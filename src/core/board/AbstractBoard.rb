# A module for any representation of a rectangular grid of a finite amount of
# other AbstractBoards. It includes the enumerable module, enumerating over 
# every subboard left to right, top to bottom. Here, a subboard is any
# AbstractBoard that is contained in the grid.
#
# Classes that include this one must implement a [](x, y) method which returns
# a space at index (x, y), or at index (x) if y is nil
# @author Dylan Frese
module AbstractBoard
    include Enumerable

    # @param [AbstractBoard] value The 'parent' board, an AbstractBoard which 
    #   contains this board as a subboard. This may be nil, but is unique if 
    #   set.
    attr_writer :parent

    @parent = nil

    # Gets the specified column of subboards from the grid, and stores it in an
    # array.
    # @param [Integer] x which column to return. This is the 0-indexed position
    #   from the left edge of the grid.
    # @return [Array<AbstractBoard>] An array of the subboards which make up
    #   column x.
    def column(x)
        Array.new(height) {|y| self[x, y]}
    end

    # Gets the specified row of subboards from the grid, and stores it in an
    # array.
    # @param [Integer] y which row to return. This is the 0-indexed position
    #   from the top edge of the grid.
    # @return [Array<AbstractBoard>] An array of the subboards which make up
    #   row y.
    def row(y)
        Array.new(width) {|x| self[x, y]}
    end

    # Composes an array of each column in the grid.
    # @return [Array<Array<AbstractBoard>>] an array of every column in the
    #   grid as returned by the @see column method.
    def columns
        Array.new(width) {|x| column(x)}
    end

    # Composes an array of each row in the grid.
    # @return [Array<Array<AbstractBoard>>] an array of every row in the
    #   grid as returned by the @see row method.
    def rows
        Array.new(height) {|y| row(y)}
    end

    # Gets the 'major diagonal' of subboards, i.e., the diagnoal going from the
    # top-left to the bottom-right of the grid.
    # @raise [TypeError] if the board is not square.
    # @return [Array<AbstractBoard>] an array of every subboard in the major
    #   diagonal.
    def major_diagonal
        raise TypeError,
            "Diagonal not defined for a non-square board!" if !square?
        Array.new(size) {|x| self[x, x]}
    end

    # Gets the 'minor diagonal' of subboards, i.e., the diagnoal going from the
    # top-right to the bottom-left of the grid.
    # @raise [TypeError] if the board is not square.
    # @return [Array<AbstractBoard>] an array of every subboard in the minor
    #   diagonal.
    def minor_diagonal
        raise TypeError,
            "Diagonal not defined for a non-square board!" if !square?
        Array.new(size) {|x| self[x, size - 1 - x]}
    end

    # Composes an array of both diagonals in the grid.
    # @return [Array<Array<AbstractBoard>>] an array consisting of the major
    # diagonal and the minor diagonal.
    def diagonals
        [major_diagonal, minor_diagonal]
    end

    # The size of a square grid. This is only defined if the board is square,
    # that is, square? returns true. In this case, it is equivalent to a call
    # to width or height.
    # Note that this is not the number of spaces in the grid, but the side
    # length (@see AbstractBoard#spaces).
    # @raise [TypeError] if the board is not square.
    # @return [Integer] the side length (width or height) of a square board.
    def size
        raise TypeError, "Size not defined for a non-square board!" if !square?
        return width
    end

    # The number spaces in the grid.
    # @return [Integer] the number of spaces in the grid.
    def spaces
        return width * height
    end
        
    # Determines if the board is square, or if the width is equal to the
    # height.
    # @return [Boolean] whether the board is square.
    def square?
        return width == height
    end

    # Whether the board has been won or not. The logic to determine the winner
    # is external to the AbstractBoard class.
    # @return [Boolean] whether the board has been won or not.
    def winner?
        winner != nil
    end

    # The current value of the winner attribute.
    # @return [Boolean] the currently set winner.
    def winner
        @winner
    end

    # A utility method to check if a set of spaces all have the same value.
    # @param [Enumerable<Integer,AbstractBoard>] spaces a set of subboards.
    #   These may be the boards themselves, or a set of indices.
    # @return [AbstractBoard,Boolean] if every space has the same value,
    #   returns that value. Otherwise, returns false. The value of a
    #   space is obtained by calling the value method on it.
    def spaces_same?(*spaces)
        sample = flattened.first
        if sample.is_a? Enumerable
            spaces = value
            sample = spaces.first
        end
        if sample.is_a? Integer
            return spaces.all? {|index| value(index) == value(sample)} &&
                value(sample)
        else
            return spaces.all? {|space| space.value == sample.value} &&
                sample.value
        end
    end

    # Gets the value of a certain subboard, or this AbstractBoard. If x is nil,
    # it returns the value of this board, defined by the result of a call to
    # AbstractBoard#winner. If x and y are both not nil, it is the result of
    # self[x, y].value. Otherwise, it is the result of self[x].value.
    # @param [Integer] x the index of the subboard. If y is not nil, it is the
    #   x-index of the subboard. If it is nil, the result of this method is the
    #   value of this AbstractBoard.
    # @param [Integer] y the y-index of the subboard. May be nil.
    # @return [Mark] the value of the specified AbstractBoard.
    def value(x = nil, y = nil)
        if x
            if y
                self[x, y].value
            else
                self[x].value
            end
        else
            winner
        end
    end

    # Returns the root of the AbstractBoard tree, where leaf nodes are
    # subboards.
    # @return [AbstractBoard] the root of the tree.
    def root
        return @parent.root if @parent
        self
    end

    # Finds the depth of the AbstractBoard tree below this node. This
    # terminates on Marks or other subboards which have no children.
    # @return [Integer] the depth of the AbstractBoard tree.
    def depth
        map do |subboard|
            subboard.depth + 1
        end.max
    end

end
