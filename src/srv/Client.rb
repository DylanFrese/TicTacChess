require_relative '../core/event/UserSet'
require 'stringio'
require 'yaml'
#assume all events will be required before this is loaded

class Client

    attr_reader :user

    def initialize(socket)
        @socket = socket
        @data = StringIO.new
        @queue = Array.new
        @last_received = Time.now
    end

    def event
        @queue.last
    end

    def event?
        @queue.empty?
    end

    def pop
        @queue.pop
    end

    def update
        begin
            loop do
                char = @socket.read_nonblock(1)
                if char == "\0"
                    yaml = @data.string
                    @data = StringIO.new
                    event = YAML::load(yaml)
                    if event.is_a? UserSet
                        set_name(event)
                    elsif !user
                        raise ArgumentError, "First event must set user!"
                    end
                    @queue << event
                else
                    @data << char
                    @last_received = Time.now
                end
            end
        rescue IO::WaitReadable
        end
        
        if stale?
            raise IOError, "Client timed out."
        end
    end

    def stale?
        Time.now - @last_recieved > 300
    end

    def set_name(event)
        raise ArgumentError, "Cannot change username!" if @user
        @user = event.user
    end

end
