# frozen_string_literal: true

require_relative 'helper'

ping_command = CommandBot::Command.new(
  name: 'ping',
  aliases: ['p'],
  data: {
    description: 'ping-pong',
    description_long: 'Ping-pong.'
  }
) do |_bot, _arguments, _options, _data|
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
) do |bot, arguments, _options, _data|
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

command_identifier1 = CommandBot::CommandIdentifier.default(prefix: '!')
command_identifier2 = CommandBot::CommandIdentifier.default(prefix: '?')

bot1 = CommandBot::Bot.new(identifier: command_identifier1)
bot1.add_commands(ping_command, help_command)

bot2 = CommandBot::Bot.new(identifier: command_identifier2)
bot2.add_commands(help_command, ping_command)

puts 'Awaiting input:'
loop do
  text = gets.chomp
  break if text.empty?

  re1 = bot1.handle(text)
  puts re1 if re1

  re2 = bot2.handle(text)
  puts re2 if re2
end
