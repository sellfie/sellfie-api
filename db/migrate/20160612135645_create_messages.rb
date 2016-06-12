class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :from, references: :users
      t.references :to, references: :users
      t.string :content
      t.datetime :seen_at

      t.timestamps null: false
    end

    add_foreign_key :messages, :users, column: :from_id
    add_foreign_key :messages, :users, column: :to_id
  end
end
