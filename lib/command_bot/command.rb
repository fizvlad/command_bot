# frozen_string_literal: true

module CommandBot
  # Stores command handler.
  class Command
    # Initalize new command.
    # @param name [String]
    # @param aliases [Array<String>]
    # @param data [Hash]
    # @yieldparam bot [Bot]
    # @yieldparam arguments [Array<String>]
    # @yieldparam options [Hash<String, String>]
    # @yieldparam other [Array<void>]
    # @yieldreturn [void]
    def initialize(name: '', aliases: [], data: {}, &handler)
      @name = name
      @aliases = aliases
      @data = data

      @handler = handler
    end

    # @return [String]
    attr_reader :name

    # @return [Array<String>]
    attr_reader :aliases

    # @return [Hash]
    attr_reader :data

    # @return [Proc]
    attr_reader :handler

    # @return [Array<String>]
    def all_aliases
      aliases + [name]
    end

    # @param names [Array<String>]
    # @return [Boolean]
    def name_matches?(*names)
      all_aliases.any? { |a| names.include?(a) }
    end
  end
end
