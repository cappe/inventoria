class EditArticlesAttributes < ActiveRecord::Migration[5.2]
  def self.up
    add_column :articles, :gtin, :string

    sql = "UPDATE articles SET gtin = gtin13;"
    ActiveRecord::Base.connection.execute(sql)

    change_column_null :articles, :gtin, false

    remove_columns :articles, :gtin13, :gtin14
  end

  def self.down
    add_column :articles, :gtin13, :string
    add_column :articles, :gtin14, :string

    sql = "UPDATE articles SET gtin13 = gtin, gtin14 = gtin;"
    ActiveRecord::Base.connection.execute(sql)

    change_column_null :articles, :gtin13, false
    change_column_null :articles, :gtin14, false

    remove_column :articles, :gtin
  end
end
