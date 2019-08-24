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

  namespace :orders do
    desc 'Processes orders that need to be delivered immediately'
    task process_deliver_now: :environment do
      Orders::DeliverOrders.call({
        with_status: :deliver_now
      })
    end

    desc 'Processes pending orders'
    task process_pending: :environment do
      Orders::DeliverOrders.call({
        with_status: :pending
      })
    end
  end
end
