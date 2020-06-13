# frozen_string_literal: true

require_relative 'helper'

class CommandBotTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CommandBot::VERSION
  end
end
