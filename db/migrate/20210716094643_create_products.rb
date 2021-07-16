class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.integer :genre_id, null: false
      t.string :name, null: false
      t.text :description, null: false
      t.integer :base_price, null: false
      t.string :product_image_id, null: false
      t.boolean :sale_status, null: false, default: true

      t.timestamps
    end
  end
end
