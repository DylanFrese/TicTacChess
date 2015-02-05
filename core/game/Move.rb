class Move
    attr_reader :atom, :player, :location

    def initialize(location, atom, player)
        @atom = atom
        @location = location
        @player = player
    end
end
