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
        raise "Diagonal not defined for a non-square board!" if !square?
        Array.new(size) {|x| self[x, x]}
    end

    def minor_diagonal
        raise "Diagonal not defined for a non-square board!" if !square?
        Array.new(size) {|x| self[x, size - 1 - x]}
    end

    def diagonals
        [major_diagonal, minor_diagonal]
    end

    def size
        raise "Size not defined for a non-square board!" if !square?
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
        value = nil
        spaces.flatten!
        spaces.each do |space|
            value ||= space
            return false if value != space
        end
        return value
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
