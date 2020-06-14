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
    # @return [CommandCall, nil] +nil+ if not a command.
    def call(bot, text, data)
      @identifier.call(bot, text, data)
    end

    # @param prefix [String] command prefix.
    # @param disallow_whitespace [Boolean] whether to disallow whitespace
    #   between prefix and command name.
    # @param o_prefix [String] prefix of option key.
    # @param o_separator [String] separator between option and value.
    # @return [CommandIdentifier]
    def self.default(prefix: '', disallow_whitespace: false, o_prefix: '--', o_separator: '=') # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      new do |bot, text_original, data|
        command_call = CommandCall.new(bot, text_original, data)
        text = text_original.dup

        # Not a command if got prefix and text do not start with it
        next nil unless prefix.empty? || text.delete_prefix!(prefix)
        # Check for whitespace
        next nil if disallow_whitespace && text.lstrip!

        words = text.split
        next nil if words.empty? # Just a prefix

        command_name = words.shift
        command_name&.downcase! # Usually commands should not depend on case, so downcasing

        options = _get_options(words, o_prefix, o_separator)

        command_call.command = bot.find_command(command_name)
        command_call.arguments = words # Everything left is considered to be arguments
        command_call.options = options
        command_call
      end
    end

    # @return [CommandIdentifier] primitive optionless identifier.
    def self.primitive
      new do |bot, text, data|
        command_call = CommandCall.new(bot, text, data)
        words = text.split
        command_call.command = bot.find_command(words.shift || '')
        command_call.arguments = words
        command_call.options = {}
        command_call
      end
    end

    # Utility method to get options hash from words array (it *will* be modified).
    # @param words [Array<String>]
    # @param prefix [String] prefix of option key.
    # @param separator [String] separator between option and value.
    def self._get_options(words, prefix, separator)
      options = {}
      while words.first&.start_with?(prefix)
        str = words.shift
        str.downcase!
        str.delete_prefix! prefix

        # Need to check for splitter in key
        key, *, value = str.partition(separator)

        # Following line allows writing '!command --key = val' with words=['--key', '=', 'val']
        *, value = words.shift(2) if value.empty? && words.first == separator

        options[key] = value || ''
      end
      options
    end
  end
end
