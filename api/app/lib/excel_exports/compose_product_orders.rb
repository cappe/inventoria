module ExcelExports
  class ComposeProductOrders
    attr_accessor :workbook,
                  :worksheet

    FIRST_ROW               = 1.freeze

    INVENTORY_NAME_COLUMN   = 1.freeze
    ARTICLE_NAME_COLUMN     = 2.freeze
    GTIN_COLUMN             = 3.freeze
    PID_COLUMN              = 4.freeze
    UNIT_COLUMN             = 5.freeze
    DELIVERY_COLUMN         = 6.freeze

    def initialize
      self.workbook = RubyXL::Workbook.new
      self.worksheet = self.workbook.worksheets[0]

      self.set_meta
    end

    def set_meta
      self.worksheet.sheet_name = 'Tilaukset'

      self.worksheet.add_cell(FIRST_ROW, INVENTORY_NAME_COLUMN, 'Varastot')

      self.worksheet.add_cell(FIRST_ROW, ARTICLE_NAME_COLUMN, 'Nimi')
      self.worksheet.add_cell(FIRST_ROW, GTIN_COLUMN, 'GTIN')
      self.worksheet.add_cell(FIRST_ROW, PID_COLUMN, 'PID')
      self.worksheet.add_cell(FIRST_ROW, UNIT_COLUMN, 'Unit')
    end

    def write(inventories)
      row = FIRST_ROW + 2

      inventories.each do |inventory|
        self.worksheet.add_cell(row, INVENTORY_NAME_COLUMN, inventory.name)

        inner_row = row

        inventory.orders.each do |order|
          self.worksheet.add_cell(inner_row, ARTICLE_NAME_COLUMN, order.article.name)
          self.worksheet.add_cell(inner_row, GTIN_COLUMN, order.article.gtin)
          self.worksheet.add_cell(inner_row, PID_COLUMN, order.article.pid)
          self.worksheet.add_cell(inner_row, UNIT_COLUMN, order.article.unit)

          if order.deliver_now?
            self.worksheet.add_cell(inner_row, DELIVERY_COLUMN, 'Pikatilaus')
          end

          inner_row += 1
        end

        row = inner_row + 1
      end
    end

    def export_as_stream
      self.workbook.stream.string
    end

    def self.compose_xlsx(inventories)
      exporter = new

      exporter.write(inventories)
      exporter.export_as_stream
    end
  end
end
