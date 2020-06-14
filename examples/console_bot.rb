# frozen_string_literal: true

require_relative 'helper'

bot = CommandBot::Bot.new(identifier: CommandBot::CommandIdentifier.primitive)
bot.add_commands(PingCommand, HelpCommand)

puts 'Awaiting input:'
loop do
  text = gets.chomp
  break if text.empty?

  re = bot.handle(text)
  puts re if re
end
