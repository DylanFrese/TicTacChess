# This represents a message, usually sent by some player. It contains
# information about the sender, the recipients, and the content of the message
# itself.
# @author Dylan Frese
class Message

    # @return [String] the content of the message
    attr_reader :message

    # @return [String,Hash<String=>String>] the sender information
    attr_reader :sender

    # @return [String,Array<String>] the recipient information
    attr_reader :recipients

    # Create a new message with the specified content, sender, and recipients.
    #
    # By default, recipients is nil; this indicates that the message is
    # intended to be received by all.
    #
    # The sender can be a string, or a Hash of string-to-string values. The
    # latter is useful when there are multiple components of information to
    # indicate, such as a user and a player name.
    #
    # The recipients parameter may be a list of strings, or a single string.
    # These strings can be usernames, playernames, etc. How they're handled
    # depends on the implementation of the client/server.
    #
    # @param [String] message the content of the message
    # @param [String,Hash<String=>String>] sender the sender of the message
    # @param [String,Array<String>] recipients the intended recipient(s)
    def initialize(message, sender, recipients)
        @message = message
        @sender = sender
        @recipietns = recipients
    end
end
