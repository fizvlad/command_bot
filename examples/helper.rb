# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'command_bot'

PingCommand = CommandBot::Command.new(
  name: 'ping',
  aliases: ['p'],
  data: {
    description: 'ping-pong',
    description_long: 'Ping-pong.'
  }
) do |_bot, _arguments, _options, _data|
  'pong'
end

HelpCommand = CommandBot::Command.new(
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
