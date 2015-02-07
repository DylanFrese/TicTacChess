class Canvas

    attr_reader :width, :height

    def initialize(width = 80, height = 40)
        @chars = Array.new(width * height){' '}
        @width = width
        @height = height
    end

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
        if value.respond_to? :chr
            @chars[index] = value.chr
        else
            @chars[index] = value.to_s.chr
        end
    end

    def [](x, y = nil)
        if y
            @chars[x + y * width]
        else
            @chars[x]
        end
    end

    def to_s
        @chars.each_slice(width).map do |line|
            line.join("")
        end.join("\n")
    end
end
