# frozen_string_literal: true

require 'logger'

module CommandBot
  # Main class.
  class Bot
    # Initialize new bot.
    # @paran identifier [CommandIdentifier] defaults to {CommandIdentifier.default}.
    # @param logger [Logger]
    # @param log_level [Logger::Severity]
    # @param command_not_found [Proc] process to execute when command can't be
    #   identified. Accepts single argument of {CommandCall}. Defaults to returning +nil+.
    def initialize(identifier: nil, logger: nil, log_level: Logger::INFO, command_not_found: nil)
      @identifier = identifier || CommandIdentifier.default
      @command_not_found = command_not_found || proc { |_command_call| nil }

      @commands = []

      log_formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime}] #{severity} - #{progname || object_id}:\t #{msg}\n"
      end
      @logger = logger || Logger.new(STDOUT, formatter: log_formatter)
      @logger.level = log_level
    end

    # @return [Array<Command>]
    attr_reader :commands

    # @param name [String]
    # @return [Command, nil]
    def find_command(name)
      logger.debug "Searching for command `#{name}`"
      commands.find { |c| c.name_matches?(name) }
    end

    # Add new commands.
    # @param commands [Command]
    def add_commands(*commands)
      logger.debug "Adding #{commands.size} new commands"
      all_aliases_array = all_aliases
      commands.each { |c| add_command_unless_alias_is_in_array(c, all_aliases_array) }
    end

    # Remove commands.
    # @param commands [Command, String]
    def remove_commands(*commands)
      logger.debug "Removing #{commands.size} commands"
      command_names = commands.map { |c| c.is_a?(String) ? c : c.name }
      @commands.reject! { |ec| ec.name_matches?(*command_names) }
    end

    # Handle message.
    # @param text [String] message text.
    # @param data [Hash] additional data which should be passed to handler procedure.
    # @return [void, nil] result depends on handler of command.
    def handle(text, data = {})
      logger.debug "Handling text: `#{text}` with additional data: #{data}"
      command_call = identify_command_call(text, data)
      return nil if command_call.nil? # Not a command call, so not handling.

      handle_command_call(command_call)
    end

    # Hadnle {CommandCall}.
    # @param command_call [CommandCall]
    # @return [void, nil] result depends on handler of command.
    def handle_command_call(command_call)
      logger.debug "Hadnling command call: #{command_call}"
      if command_call.command
        execute_command_call(command_call)
      else
        command_not_found(command_call)
      end
    end

    private

    # @return [Logger]
    attr_reader :logger

    # @return [Array<String>]
    def all_aliases
      re = @commands.map(&:all_aliases)
      re.flatten!
      re
    end

    # @note modifies +all_aliases_array+
    def add_command_unless_alias_is_in_array(command, all_aliases_array)
      command_aliases = command.all_aliases
      intersection = all_aliases_array & command_aliases
      if intersection.empty?
        @commands << command
        all_aliases_array.concat(command_aliases)
      else
        logger.warn "Command #{command.name} will not be added due to name intersection!"
      end
    end

    # @return [CommandCall, nil]
    def identify_command_call(text, data)
      @identifier.call(self, text, data)
    end

    # @return [void]
    def execute_command_call(command_call)
      command_call.execute
      # NOTE: it is possible to execute it from here, but IHMO command_call should
      #   be able to execute itself.
    end

    def command_not_found(command_call)
      @command_not_found.call(command_call)
    end
  end
end
