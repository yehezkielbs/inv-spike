class CreateSaleDetails < ActiveRecord::Migration
  def self.up
    create_table :sale_details do |t|
      t.references :sale
      t.references :item
      t.integer :qty

      t.timestamps
    end
  end

  def self.down
    drop_table :sale_details
  end
end
