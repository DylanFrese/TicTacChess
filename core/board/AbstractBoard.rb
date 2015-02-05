module AbstractBoard
    attr_writer :parent
    @parent = nil
    @dirty = false

    DEFAULT_WIN = Proc.new {|board|
        check = Proc.new do |set|
            set.all? {|x| x.value == set[0].value}
        end
        if board.square?
            sets = board.rows + board.columns + board.diagonals
        else
            sets = board.rows + board.columns
        end
        sets.detect {|x| check[x]}[0].value
    }

    def dirty=(x)
        @dirty = x
        if x && @parent
            @parent.dirty = true
        end
    end

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
        check_for_winner if @dirty
        @winner
    end

    def check_for_winner(&block)
        return if @winner
        @winner = (block || DEFAULT_WIN)[self]
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

end
