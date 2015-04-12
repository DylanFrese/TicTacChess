# A class for rendering a Mark. More precisely, this class renders some Mark at
# some index in a larger AbstractBoard.
# @author Dylan Frese
class MarkRenderer

    # Creates a new MarkRenderer to render the mark at the specified index of
    # the specified board.
    # @param [AbstractBoard] board the board whose Mark is to be rendered
    # @param [Integer] x the x-index of the Mark, or, if y is nil, the index of
    #   the Mark.
    # @param [Integer] y the y-index of the Mark.
    def initialize(board, x, y = nil)
        @board = board
        if y
            @index = x + y * board.width
        else
            @index = x
        end
    end

    # @return [Mark] the Mark to be rendered.
    def mark
        @board[@index]
    end
    
    # The width of the result of the render. This is always 1 since a Mark is a
    # single character.
    # @return [Integer] 1
    def width
        1
    end

    # The height of the result of the render. This is always 1 since a Mark is
    # a single character.
    # @return [Integer] 1
    def height
        1
    end

    # Renders the Mark onto a Canvas at the specified location, or creates a
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
        canvas ||= Canvas.new(1, 1)
        x ||= 0
        y ||= 0
        canvas[x, y] = mark.chr
        canvas
    end
end
