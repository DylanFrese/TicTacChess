module AbstractBoard
    include Enumerable

    attr_writer :parent
    @parent = nil

    def column(x)
        Array.new(height) {|y| self[x, y]}
    end

    def row(y)
        Array.new(width) {|x| self[x, y]}
    end

    def columns
        Array.new(width) {|x| column(x)}
    end

    def rows
        Array.new(height) {|y| row(y)}
    end

    def major_diagonal
        raise TypeError,
            "Diagonal not defined for a non-square board!" if !square?
        Array.new(size) {|x| self[x, x]}
    end

    def minor_diagonal
        raise TypeError,
            "Diagonal not defined for a non-square board!" if !square?
        Array.new(size) {|x| self[x, size - 1 - x]}
    end

    def diagonals
        [major_diagonal, minor_diagonal]
    end

    def size
        raise TypeError, "Size not defined for a non-square board!" if !square?
        return width
    end

    def spaces
        return width * height
    end
        
    def square?
        return width == height
    end

    def winner?
        winner != nil
    end

    def winner
        @winner
    end

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

    def root
        return @parent.root if @parent
        self
    end

    def depth
        map do |subboard|
            subboard.depth + 1
        end.max
    end

end
