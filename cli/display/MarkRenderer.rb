class MarkRenderer

    def initialize(board, x, y = nil)
        @board = board
        if y
            @index = x + y * board.width
        else
            @index = x
        end
    end

    def board
        @board[@index]
    end
    
    def width
        1
    end

    def height
        1
    end

    def render(canvas = nil, x = nil, y = nil)
        canvas ||= Canvas.new(width(board), height(board))
        x ||= 0
        y ||= 0
        canvas[x, y] = board.chr
    end
end
