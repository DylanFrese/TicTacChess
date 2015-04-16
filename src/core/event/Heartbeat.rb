require_relative 'Event'

class Heartbeat < Event
    def initialize
        super(:CON_HEARTBEAT, 6)
    end
end
