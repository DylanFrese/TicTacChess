require_relative '../board/Mark'

class Player

    SYMBOLS="XO+#*/@ΔΩ123456789"

    def self.generate_i(players)
        if players > SYMBOLS.size
            raise "Unable to generate more than #{SYMBOLS.size} players, please specify the marks yourself."
        end
        return Marks.each_char.take(players).map {|char| Mark.new(char)}
    end

    def self.generate_m(marks)
        marks.map.each_with_index do |mark, index|
            Player.new(mark, :name => "Player #{index + 1}")
        end
    end

    private_class_method :generate_i, :generate_m

    def self.generate(players)
        if players.is_a? Integer
            return generate_m(generate_i(players))
        elsif players[0].is_a? String
            return generate_m(players.each_char.map {|char| Mark.new(char)})
        elsif players[0].is_a? Mark
            return generate_m(players)
        end
    end

    attr_reader :mark, :name

    def initialize(mark, properties = Hash.new)
        @mark = mark
        @name = properties.delete(:name) || "Player"
    end
end
