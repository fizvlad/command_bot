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
    def self.default(prefix: '', disallow_whitespace: false, o_prefix: '--', o_separator: '=')
      new do |bot, text_original, data|
        command_call = CommandCall.new(bot, text_original, data)
        text = text_original.dup

        # Not a command if got prefix and text do not start with it
        next nil unless prefix.empty? || text.delete_prefix!(prefix)
        # Check for whitespace
        next nil if disallow_whitespace && text.lstrip!

        words = text.split
        # Name
        command_name = words.shift
        next nil if command_name.nil? # Just a prefix
        command_name.downcase! # Usually commands should not depend on case, so downcasing
        # Options
        options = {}
        while words.first&.start_with? o_prefix
          o_str = words.shift
          o_str.downcase!
          o_str.delete_prefix! o_prefix

          # Need to check for splitter in key
          o_key, *, o_value = o_str.partition(o_separator)

          # Following block allows writing '!command --key = value'
          o_value = nil if o_value.empty?
          o_value ||= if words.first == o_separator
                        *, o_value = words.shift 2
                        o_value || ''
                      else
                        ''
                      end
          options[o_key] = o_value
        end

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
  end
end
