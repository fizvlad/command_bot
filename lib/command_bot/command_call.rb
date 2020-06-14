# frozen_string_literal: true

module CommandBot
  # Stores command call information.
  class CommandCall
    # New command call.
    # @param bot [Bot]
    # @param text [String]
    # @param data [Hash]
    def initialize(bot, text, data)
      @bot = bot
      @text = text
      @data = data

      @command = nil
      @arguments = []
      @options = {}
    end

    # @return [Bot]
    attr_reader :bot

    # @return [String]
    attr_reader :text

    # @return [Hash]
    attr_reader :data

    # @return [Command, nil] +nil+ if command can't be found.
    attr_accessor :command

    # @return [Array<String>]
    attr_accessor :arguments

    # @return [Hash<String, String>]
    attr_accessor :options

    # Executes command.
    # @return [void]
    def execute
      raise 'Command not identified!' if command.nil?

      command.handler.call(bot, arguments, options, data)
    end

    # @return [String]
    def to_s
      if command.nil?
        "COMMAND_NOT_FOUND(`#{text}`)"
      else
        arg_str = arguments.join(', ')
        opt_str = options.map { |k, v| "#{k}: #{v}" }.join(', ')
        "#{command.name}[#{arg_str}]{#{opt_str}}"
      end
    end
  end
end
