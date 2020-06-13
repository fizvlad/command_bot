# frozen_string_literal: true

require_relative 'helper'

class CommandTest < Minitest::Test
  def test_all_aliases
    command = CommandBot::Command.new(name: 'help', aliases: %w[h1 h2]) {}
    all_aliases = command.all_aliases
    assert all_aliases.size == 3, 'Wrong aliases amount'
    assert all_aliases.include?('help'), 'Missing name'
    assert all_aliases.include?('h1'), 'Missing name'
    assert all_aliases.include?('h2'), 'Missing name'
  end

  def test_name_matching
    command = CommandBot::Command.new(name: 'help', aliases: %w[h1 h2]) {}
    assert command.name_matches?('help'), 'Name not matched'
    assert command.name_matches?('h1'), 'Name not matched'
    assert command.name_matches?('h2'), 'Name not matched'
    assert !command.name_matches?('h3'), 'Wrong name matched'
  end
end
