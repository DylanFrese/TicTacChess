require_relative 'BoardRenderer'

class StandardRenderer
    
    def initialize(game, chat=nil)
        @game = game
        @board_renderer = BoardRenderer.new(game.board)
        @message_length = [@board_renderer.width, 60].max
        @chat_separator = @message_length + 2
        @chat_x = @chat_separator + 2
        @message_y = @board_renderer.height + 1
        @canvas = Canvas.new(120, 20)
        @message = nil
        @chat = chat
    end

    def width
        @canvas.width
    end

    def height
        @canvas.height
    end

    def set_message(message)
        @message = message
        if message
            @split_message = split_string(message, @message_length)
        end
    end

    def render
        render_board
        render_message
        if @chat
            render_chat
        end
        @canvas
    end

    def render_board
        @canvas.clear(0, 0, @board_renderer.width, @board_renderer.height)
        @board_renderer.render(@canvas)
    end

    def render_message
        @canvas.clear(0, @message_y, @message_length, height - @message_y - 1)
        if @message
            @split_message.each_with_index do |message, index|
                @canvas.render_string(string, 0, @message_y + index)
            end
        end
    end

    def render_chat
        p @chat
        return if @last_message && @last_message.equal?(@chat.first)
        @canvas.clear(@chat_separator, 0,
                      width - @chat_separator - 1, height + 1)
        0.upto(height) do |y|
            @canvas[@chat_separator, y] = "\u2502"
        end
        message_width = width - @chat_x - 1
        @chat.lazy.
            flat_map {|message| split_string(message, message_width).reverse}.
            take(height).
            to_a.
            reverse.
            each_with_index do |line, index|
                @canvas.render_string(line, @chat_x, index)
            end
    end

    private :render_board, :render_message, :render_chat

    def self.split_string(string, length)
        return [string] if string.size <= length
        last = nil
        incl = false
        start = 0
        array = []
        string.each_char.each_with_index do |char, index|
            if char == "\n"
                array << string[start ... index]
                start = index + 1
                last = nil
                incl = false
            elsif (index - start) > length
                if !last
                    last = index
                    incl = true
                end
                if incl
                    array << string[start .. last]
                else
                    array << string[start ... last]
                end
                start = last + 1
                last = nil
            elsif /\s/ === char
                last = index 
                incl = false
            elsif /[,\.-\/\\]/ === char
                last = index
                incl = true
            elsif /[()\[\]\{\}<>]/ === char 
                last = index - 1
                incl = true
            end
        end
        array << string[start .. -1]
    end

    private_class_method :split_string

end
