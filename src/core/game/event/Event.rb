# This class represents some event that has happened in the game. This could be
# anything from a chat message to a new game to a move. This class should not
# be instantiated directly.
# @author Dylan Frese
class Event

    # @return [Symbol] the name of this Event type
    attr_reader :name

    # @return [Integer] the short ID number of this Event type
    attr_reader :id

    # @return [Time] the time this event was instantiated
    attr_reader :time

    # Creates a new event with the given parameters. The name and id are
    # required, and should be the same for all events of a single type.
    # @param [Symbol] name the long name of this type of event
    # @param [Integer] id the ID of the event type
    def initialize(name, id)
        @name = name
        @id = id
        @time = Time.now
    end
end
