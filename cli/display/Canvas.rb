class Canvas

    def initialize(width=80, height=40)
        @chars = Array.new(width * height){' '}
    end

    def []=(x, y, z = nil)
        if z
            index = x + y * width
            value = z
        else
            index = x
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

end
