module ExcelImports
  class Articles
    attr_accessor :workbook

    def initialize(params)
      raise 'file_path is missing' unless params[:file_path]

      self.workbook = RubyXL::Parser.parse(params[:file_path])
    end

    def read
      worksheet = self.workbook[0]

      6.upto(Float::INFINITY) do |row_index|
        row = worksheet[row_index]

        break if row.nil?

        params = {
          pid: row[1]&.value&.to_s.strip,
          name: row[2]&.value&.to_s.strip,
          gtin13: row[3]&.value&.to_s.strip,
          gtin14: row[4]&.value&.to_s.strip,
          unit: row[5]&.value&.to_s.strip,
        }

        article = Article.new(params)

        unless article.save
          puts "Errors: #{article.errors.full_messages}; Params: #{params}".red
        end
      end
    end

    def self.import(params)
      importer = new(params)

      execution_time = Benchmark.measure {
        Article.transaction do
          importer.read
        end
      }

      puts "All good!".green
      puts "Execution time: #{execution_time}".blue
    end
  end
end
