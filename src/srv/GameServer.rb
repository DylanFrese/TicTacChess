require_relative '../core/game/Game'
require_relative '../core/event/NewGameEvent'
require_relative '../core/event/Move'
require_relative '../core/event/GameUpdate'
require_relative '../core/chat/Message'
require_relative 'Client'
require 'yaml'

class GameServer

    def initialize(socket)
        @socket = socket
        @chat = Array.new
        @clients = Array.new
    end

    def game
        @game
    end

    def send_all(event)
        @clients.each {|client| send(client, event)}
    end

    def send(client, event)
        client.write(YAML::dump(event))
        client.write("\0")
    end

    def send_fail(client, exception)
        client.write(YAML::dump(exception))
    end

    def update_state(client)
        send(client, GameUpdate.new(game))
    end

    def new_game(game)
        @game = game
        send_all(NewGameEvent.new(game))
    end

    def move(move)
        game.move(move)
        send_all(move)
    end

    def message(user, message)
        verify_sender(user, message)
        @chat << message
        clients_from_recipients(message.recipients) do |client|
            send(client, message)
        end
    end

    def clients_from_recipients(message)
        @clients if !message.recipients
        if message.recipients.is_a? Array
            recipients = message.recipients
        elsif message.recipients.is_a? String
            recipients = [message.recipients]
        end

        block = block_given?
        clients = [] unless block
        recipients.each do |recipient|
            result = @clients.find {|client| client.user == recipient}
            if block
                yield result if result
            else
                clients << result
            end
        end
        return clients unless block
    end

    def verify_sender(user, message)
    end

    def update
        begin
            @clients << Client.new(@socket.accept_nonblock)
        rescue IO::WaitReadable
        end
        @clients.each do |client|
            begin
                client.update
                process(client, client.pop) if client.event?
            rescue IOError => exception
                drop_client(client)
            rescue => exception #If there was a failure reading
                send_fail(client, exception)
            end
        end
    end

    def drop_client(client)
        client.close
        @clients.delete(client)
    end

    def process(client, event)
        move(event) if event.is_a? Move
        new_game(event.game) if event.is_a? NewGameEvent
        message(client.user, event) if event.is_a? Message
        update_state(client) if event.is_a? GameUpdate
    end


    def is_allowed(user, event)
        true
    end
end
