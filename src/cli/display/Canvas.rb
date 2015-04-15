# Represents a grid of characters. This is similar to what a framebuffer would
# be for graphical applications.
# @author Dylan Frese
class Canvas

    # @return [Integer] the width, in characters, of the Canvas
    attr_reader :width
    # @return [Integer] the height, in characters, of the Canvas
    attr_reader :height

    # Create a new Canvas. The characters are set to spaces.
    # @param [Integer] width the width in characters of the Canvas.
    # @param [Integer] height the height in characters of the Canvas.
    def initialize(width = 80, height = 40)
        @chars = Array.new(width * height){' '}
        @width = width
        @height = height
    end

    # Sets a character at a certain index.
    #
    # The parameters work similarly to those of Board#[]=: if three parameters
    # are set, the first two are taken to be indices and the last to be a
    # value. Otherwise, the first is taken to be the index and the second to be
    # the value.
    #
    # If the value is a String, the first character is taken. If it is not a
    # String, it is first converted to a String via the Object#to_s method.
    # @param [Integer] x the first parameter
    # @param [Integer,String,Object] y the second parameter
    # @param [String,Object] z the third parameter
    # @return [void]
    def []=(x, y, z = nil)
        if z
            index = x + y * width
            return if x > @width || y > @height
            value = z
        else
            index = x
            return if index > @chars.size
            value = y
        end
        return if index >= @chars.size
        if value.respond_to? :chr
            @chars[index] = value.chr
        else
            @chars[index] = value.to_s.chr
        end
    end

    # Gets the character at a certain position.
    # The parameters work similarly to those of Board#[]: if two parameters are
    # defined, they are taken to be the x- and y- indices. Otherwise, the first
    # parameter is taken to be the index.
    # @param [Integer] x the index, or x-index if y is not nil
    # @param [Integer] y the y-index if defined
    # @return [String] the character at the specified location
    def [](x, y = nil)
        if y
            @chars[x + y * width]
        else
            @chars[x]
        end
    end

    # 'Clears' the Canvas inside the specified rectangle with the specified
    # char. This sets every space to that character.
    # @param [Integer] x the location of the left edge of the rectangle
    # @param [Integer] y the location of the top edge of the rectangle
    # @param [Integer] width the width of the rectangle
    # @param [Integer] height the height of the rectangle
    # @return [void]
    def clear(x=0, y=0, width=width, height=height, char=" ")
        x.upto(width) do |xpos|
            y.upto(height) do |ypos|
                self[xpos, ypos] = char
            end
        end
        nil
    end

    # Renders a string on the Canvas at the specified location. This does not
    # do string splitting, and will end if it hits the edge of the Canvas.
    # @param [String,#each_char] string the string to be rendered
    # @param [Integer] x the x-position of the first character of the string
    # @param [Integer] y the y-position of the first character of the string
    # @return [void]
    def render_string(string, x, y)
        string.each_char.each_with_index do |char, index|
            return if x + index >= width
            self[x + index, y] = char
        end
    end

    # Returns the string representation of this Canvas.
    #
    # The representation is each line of characters joined by a newline.
    # @return [String] the string representation of this Canvas
    def to_s
        @chars.each_slice(width).map do |line|
            line.join("")
        end.join("\n")
    end
end
