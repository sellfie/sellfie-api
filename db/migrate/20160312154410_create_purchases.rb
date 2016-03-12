class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :buyer_id, null: false

      t.timestamps null: false
    end

    add_foreign_key :purchases, :users, column: :buyer_id
  end
end
