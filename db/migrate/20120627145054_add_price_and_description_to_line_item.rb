class AddPriceAndDescriptionToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :price, :decimal
    add_column :line_items, :description, :string
  end
end
