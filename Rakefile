require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) {}

namespace 'rubocop' do
  desc 'Generate rubocop TODO file.'
  task 'todo' do
    puts `rubocop --auto-gen-config`
  end
end

namespace 'yardoc' do
  desc 'Generate documentation'
  task 'generate' do
    puts `yardoc lib/*`
  end

  desc 'List undocumented elements'
  task 'undoc' do
    puts `yardoc stats --list-undoc lib/*`
  end
end

namespace 'eol' do
  desc 'Replace CRLF with LF.'
  task :dos2unix, [:pattern] do |_t, args|
    path_list = Dir.glob(args.pattern || '**/*.{rb,rake}', File::FNM_EXTGLOB)
    counter = 0
    path_list.each do |path|
      next unless File.file?(path)

      counter += 1
      puts "Handling `#{path}`..."
      content = File.read(path, mode: 'rb')
      content.gsub!(/\r\n/, "\n")
      File.write(path, content, mode: 'wb')
    end
    puts "Handled #{counter} files."
  end
end
