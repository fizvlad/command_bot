# frozen_string_literal: true

require_relative 'helper'

ping_command = CommandBot::Command.new(
  name: 'ping',
  aliases: ['p'],
  data: {
    description: 'ping-pong',
    description_long: 'Ping-pong.'
  }
) do |_bot, _arguments, _options, *_other|
  'pong'
end

help_command = CommandBot::Command.new(
  name: 'help',
  aliases: ['h'],
  data: {
    description: 'show help message',
    description_long: 'Show help message for specified command. Shows list of ' \
                      'command if atgument is not specified.',
    another_info: 'you can pass any data here'
  }
) do |bot, arguments, _options, *_other|
  commands = if arguments.empty?
               bot.commands
             else
               bot.commands.select { |e| arguments.include? e.name }
             end

  help_line = if arguments.empty?
                proc do |e|
                  "#{e.name} (also known as #{e.aliases.join(', ')}) " \
                  "- #{e.data[:description]}"
                end
              else
                proc do |e|
                  "#{e.name} (also known as #{e.aliases.join(', ')}) " \
                  "- #{e.data[:description]}\n#{e.data[:description_long]}"
                end
              end

  <<~HELP
    Commands list:
    #{commands.map(&help_line).join("\n")}
  HELP
end

command_identifier_1 = CommandBot::CommandIdentifier.default(prefix: '!')
command_identifier_2 = CommandBot::CommandIdentifier.default(prefix: '?')

bot_1 = CommandBot::Bot.new(identifier: command_identifier_1)
bot_1.add_commands(ping_command, help_command)

bot_2 = CommandBot::Bot.new(identifier: command_identifier_2)
bot_2.add_commands(ping_command, help_command)

puts 'Awaiting input:'
loop do
  text = gets.chomp
  break if text.empty?

  re = bot_1.handle(text)
  puts re if re
end
