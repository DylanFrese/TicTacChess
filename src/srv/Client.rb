require_relative '../core/event/UserSet'
require_relative '../core/event/Heartbeat'
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
        @last_heartbeat = Time.now
    end

    def event
        @queue.last
    end

    def event?
        !@queue.empty?
    end

    def pop
        @queue.pop
    end

    def update
        if heartbeat?
            @last_heartbeat = Time.now
            @socket.write(YAML::dump(Heartbeat.new) + "\0")
        end

        if stale?
            raise IOError, "Client timed out."
        end

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
                    else
                        @queue << event
                    end
                else
                    @data << char
                    @last_received = Time.now
                end
            end
        rescue IO::WaitReadable
        end
    end

    def close
        @socket.close
    end

    def write string
        @socket.write string
    end

    def heartbeat?
        Time.now - @last_heartbeat > 60
    end

    def stale?
        Time.now - @last_received > 300
    end

    def set_name(event)
        raise ArgumentError, "Cannot change username!" if @user
        @user = event.user
    end

end
