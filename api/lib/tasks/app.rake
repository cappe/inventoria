namespace :app do
  desc 'Imports articles from a given Excel file'
  task import: :environment do
    options = {}

    OptionParser.new do |opts|
      opts.banner = "Usage: bin/rake app:import -- [options]"

      opts.on("-f {filename}", "Filename", String) do |filename|
        options[:filename] = filename
      end
    end.parse!(ARGV[2..-1])

    file_path = "data/#{options[:filename]}"

    ExcelImports::Articles.import({
      file_path: file_path
    })

    exit 0
  end
end
