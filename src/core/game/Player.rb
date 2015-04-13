require_relative '../board/Mark'

# A player of the game. A player has a specified and usually unique Mark. A
# player may also have other properties, which, for now, is limited to a name.
# @author Dylan Frese
class Player

    # @return [String] a string of symbols to assign as the symbols for
    #   different players' Marks when generating players
    SYMBOLS="XO+#*/@ΔΩ123456789"

    # Generate a certain number of Marks, using the SYMBOLS constant as a
    # source of symbols for players' Marks.
    # @raise [RuntimeError] if the number of requested players is greater than
    #   the number of characters in the SYMBOLS constant
    # @param [Integer] number number of Marks to generate.
    # @return [Array<Mark>] an array of Marks of the requested length
    def self.generate_marks(number)
        if number > SYMBOLS.size
            raise "Unable to generate more than #{SYMBOLS.size} players,"\
                    "please specify the marks yourself."
        end
        return SYMBOLS.each_char.take(number).map {|char| Mark.new(char)}
    end

    # Generate players from a list of Marks. Player names are "Player #" where
    # the number starts at 1.
    # @param [Enumerable<Mark>] marks a list of Marks to use as the players'
    #   assigned Marks.
    # @return [Array<Player>] an array of the generated players.
    def self.generate_players_from_marks(marks)
        marks.map.each_with_index do |mark, index|
            Player.new(mark, :name => "Player #{index + 1}")
        end
    end

    private_class_method :generate_marks, :generate_players_from_marks

    # Generate some players.
    #
    # This method may take an Integer, a String, or a list of Marks or Strings.
    # If passed an Integer, the parameter corresponds to the number of players
    # generated.  If passed a String, it is interpreted to be a list of
    # symbols, where each character is a symbol, of players' Marks. If passed
    # an array of Marks, each Mark is assigned to a player. If passed an array
    # of Strings, each String is taken to be a list of symbols of players'
    # Marks.
    #
    # If passed an Integer, the Marks assigned to the generated players
    # correspond to the characters in Player::SYMBOLS.
    #
    # In each case, the names of each player are "Player #" where the number
    # is the index, starting at 1, of the player in the list.
    # @raise [TypeError] if passed an unsupported Type
    # @param [Integer,String,Array<Mark,String>] players the players to
    #   generate
    # @return [Array<Player>] a list of players
    def self.generate(players)
        marks = nil
        if players.is_a? Integer
            marks = generate_marks(players)
        elsif players.is_a? String
            marks = players.each_char.map {|char| Mark.new(char)}
        elsif players.is_a? Array
            if players[0].is_a? Mark
                marks = players
            elsif players[0].is_a? String
                marks = players.map {|string| Mark.new(string)}
            end
        end
        if marks == nil
            raise TypeError, "Unable to handle type '#{players.class}'. "\
                             "Please see documentation for supported types."
        end
        generate_players_from_marks(marks)
    end

    # @return [Mark] the Mark associated with this player
    attr_reader :mark
    # @return [String] the name of this player
    attr_reader :name

    # Creates a new player with the given Mark. Additional properties may be
    # specified as a Hash of symbols to values.
    #
    # Currently, the supported properties are:
    #   :name => String: the name of the player
    # @param [Mark] mark the mar to associate with this player
    # @param [Hash<Symbol => Object>] properties a hash of various properties
    #   of the player
    def initialize(mark, properties = Hash.new)
        @mark = mark
        @name = properties.delete(:name) || "Player"
    end

    # @return [String] the name of the player
    def to_s
        @name
    end
end
