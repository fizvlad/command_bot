# frozen_string_literal: true

require_relative 'helper'

command_identifier1 = CommandBot::CommandIdentifier.default(prefix: '!')
command_identifier2 = CommandBot::CommandIdentifier.default(prefix: '?')

bot1 = CommandBot::Bot.new(identifier: command_identifier1, log_level: Logger::DEBUG)
bot1.add_commands(PingCommand, HelpCommand)

bot2 = CommandBot::Bot.new(identifier: command_identifier2)
bot2.add_commands(HelpCommand, PingCommand)

puts 'Awaiting input:'
loop do
  text = gets.chomp
  break if text.empty?

  re1 = bot1.handle(text)
  puts re1 if re1

  re2 = bot2.handle(text)
  puts re2 if re2
end
