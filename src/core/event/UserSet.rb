require_relative 'Event'

class UserSet < Event

    attr_reader :user

    def initialize(user)
        super(:CON_USER_SET, 4)
        @user = user
    end
end
