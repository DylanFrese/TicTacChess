require_relative 'MarkRenderer'
require_relative 'Canvas'
require_relative '../../core/board/Board'
require_relative '../../core/board/Mark'

# A class to render one given Board. This class recursively creates
# BoardRenderers or MarkRenderers for each subboard as appropriate.
#
# This class is stateful and instances should only be created once for a given
# Board.
# @author Dylan Frese
class BoardRenderer

    # @return [AbstractBoard] the board being rendered
    attr_reader :board
    # @return [Integer] the width, in characters, of result of the rendering
    attr_reader :width
    # @return [Integer] the height, in characters, of result of the rendering
    attr_reader :height

    # Creates a new BoardRenderer with the specified board as a rendering
    # source. The initializer creates a BoardRenderer or MarkRenderer, as
    # appropiate, for each subboard of the specified board. The width and
    # height are then recursively calculated from the created renderers.
    # @param [AbstractBoard] board the board to be rendered
    def initialize(board)
        @board = board
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

    # Renders the board onto a Canvas at the specified location, or creates a
    # Canvas if none is specified. 
    #
    # The specification of the result of the render is as follows:
    # * Each column of subboards is assigned a width, which is determined by
    #   taking the max width of the BoardRenderer for every subboard in that
    #   column
    # * Each row of subboards is assigned a height, determined likewise
    # * Between the renderering of subboards is a gap the size of the depth of
    #   that subboard take one. That gap is referred to as a 'gutter'.
    #   Characters located in the gutter will not be modified, it is best to
    #   leave them as spaces.
    # * The location for every subboard to be rendered, it's x-offset and
    #   y-offset, is determined by summing the width of every column and gutter
    #   to the left, and by summing the height of every row and gutter above,
    #   respectively.
    # * The subboards are then rendered centred at that location. If any
    #   subboard is a Mark, then the character that represents that Mark is
    #   rendered at that location.
    #
    # @param [Canvas] canvas the Canvas to render unto. If nil, one is created.
    # @param [Integer] x the x-index to render on the specified Canvas
    # @param [Integer] y the y-index to render on the specified Canvas
    # @return [Canvas] the canvas used for rendering
    def render(canvas = nil, x = nil, y = nil)
        canvas ||= Canvas.new(width, height)
        x ||= 0
        y ||= 0
        if board.is_a? Mark
            canvas[x, y] = board.chr
        else
            @subrenderers.each_slice(@board.width).each_with_index do |row, j|
                row.each_with_index do |renderer, i|
                    xcenter = @widths[i] / 2 - renderer.width / 2
                    ycenter = @heights[j] / 2 - renderer.height / 2
                    xoff = @xoffsets[i] + x + xcenter
                    yoff = @yoffsets[j] + y + ycenter
                    renderer.render(canvas, xoff, yoff)
                end
            end
        end
        canvas
    end

    private
    # Gets a row of subrenderers.
    # @param [Integer] y the y-index of the desired row
    # @return [Enumerator<Canvas>] an Enumerator of subrenderers in that row
    def row(y)
        Enumerator.new do |yielder|
            (0 ... @board.width).each do |x|
                yielder << @subrenderers[x + y * @board.width]
            end
        end
    end

    # Gets a column of subrenderers.
    # @param [Integer] x the x-index of the desired column
    # @return [Enumerator<Canvas>] an Enumerator of subrenderers in that column
    def column(x)
        Enumerator.new do |yielder|
            (0 ... @board.height).each do |y|
                yielder << @subrenderers[x + y * @board.width]
            end
        end
    end

    # Gets all rows of subrenderers.
    # @return [Enumerator<Enumerator<Canvas>>] an Enumerator containing every
    #   row.
    def rows
        Enumerator.new do |yielder|
            (0 ... @board.height).each do |y|
                yielder << row(y)
            end
        end
    end

    # Gets all columns of subrenderers.
    # @return [Enumerator<Enumerator<Canvas>>] an Enumerator containing every
    #   column.
    def columns
        Enumerator.new do |yielder|
            (0 ... @board.width).each do |x|
                yielder << column(x)
            end
        end
    end
    
    # Gets an array of offsets from a list of widths/heights, adding the gutter
    # as appropriate.
    # @param [Array<Integer>] list the list of sizes to use to total the
    #   offsets
    # @return [Array<Integer>] an array of offsets calculated from the list
    def offsets(list)
        sum = 0
        array = Array.new
        list.each do |val|
            array << sum
            sum += val + @gutter
        end
        array
    end

    # Calculates the offsets for the widths of board renderers.
    # @return [Array<Integer>] the x-offsets of the subboards
    def xoffsets
        offsets(@widths)
    end

    # Calculates the offsets for the heights of board renderers.
    # @return [Array<Integer>] the y-offsets of the subboards
    def yoffsets
        offsets(@heights)
    end

end
