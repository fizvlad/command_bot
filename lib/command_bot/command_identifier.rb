# frozen_string_literal: true

module CommandBot
  # Stores command call information.
  class CommandIdentifier
    # Create new identifier.
    # @yieldparam bot [Bot]
    # @yieldparam text [String]
    # @yieldparam data [Hash]
    # @yieldreturn [CommandCall, nil] +nil+ if not a command.
    def initialize(&identifier)
      @identifier = identifier
    end

    # Call identifier process.
    # @param text [String]
    # @param data [Hash]
    def call(bot, text, data)
      @identifier.call(bot, text, data)
    end

    # @param [String] command prefix.
    # @return [CommandIdentifier] default identifier with prefix.
    def self.default(prefix: '')
      self.new do |bot, text, data|
        # TODO
      end
    end

    # @return [CommandIdentifier] primitive optionless identifier.
    def self.primitive
      self.new do |bot, text, data|
        command_call = CommandCall.new(bot, text, data)
        words = text.split
        command_call.command = bot.find_command(words.shift || '')
        command_call.arguments = words
        command_call.options = {}
        command_call
      end
    end
  end
end
