class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :description
      t.string :condition
      t.float :price
      t.float :shipping_fee
      t.integer :stock
      t.references :category, index: true, foreign_key: true
      t.integer :seller_id, null: false

      t.timestamps null: false
    end

    add_foreign_key :products, :users, column: :seller_id
  end
end
