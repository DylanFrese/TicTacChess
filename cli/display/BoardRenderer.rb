require_relative 'MarkRenderer'
require_relative '../../core/board/Board'
require_relative '../../core/board/Mark'

class BoardRenderer

    def self.size(renderers, gutter)
        renderers.map do |row|
            row.reduce(0) do |sum, renderer|
                sum + renderer.width + gutter
            end
        end.max
    end

    attr_reader :board, :width, :height

    def initialize(board)
        @board = board
        @mark = board.is_a? Mark
        @subrenderers = Array.new(board.spaces) do |i| 
            subboard = board[i]
            if subboard.is_a? Mark
                MarkRenderer.new(board, i)
            else
                BoardRenderer.new(subboard)
            end
        end
        @widths = columns.map do |column|
            column.max_by { |sr| sr.width }.width
        end
        @heights = rows.map do |row|
            row.max_by { |sr| sr.height }.height
        end
        @gutter = @board.depth - 1
        @width = @widths.reduce do |sum, val|
            sum + val + @gutter
        end
        @height = @heights.reduce do |sum, val|
            sum + val + @gutter
        end
        @xoffsets = xoffsets
        @yoffsets = yoffsets
    end

    def mark?
        @mark
    end

    def render(canvas = nil, x = nil, y = nil)
        canvas ||= Canvas.new(width, height)
        x ||= 0
        y ||= 0
        if board.is_a? Mark
            canvas[x, y] = board.chr
        else
            @subrenderers.each_slice(@board.width).each_with_index do |row, j|
                row.each_with_index do |renderer, i|
                    xoff = @xoffsets[i] + x + @widths[i] / 2 - renderer.width / 2
                    yoff = @yoffsets[j] + y + @heights[j] / 2 - renderer.height / 2
                    renderer.render(canvas, xoff, yoff)
                end
            end
        end
        canvas
    end

    private
    def row(y)
        Enumerator.new do |yielder|
            (0 ... @board.width).each do |x|
                yielder << @subrenderers[x + y * @board.width]
            end
        end
    end

    def column(x)
        Enumerator.new do |yielder|
            (0 ... @board.height).each do |y|
                yielder << @subrenderers[x + y * @board.width]
            end
        end
    end

    def rows
        Enumerator.new do |yielder|
            (0 ... @board.height).each do |y|
                yielder << row(y)
            end
        end
    end

    def columns
        Enumerator.new do |yielder|
            (0 ... @board.width).each do |x|
                yielder << column(x)
            end
        end
    end
    
    def offsets(list)
        sum = 0
        array = Array.new
        list.each do |val|
            array << sum
            sum += val + @gutter
        end
        array
    end

    def xoffsets
        offsets(@widths)
    end

    def yoffsets
        offsets(@heights)
    end

end
