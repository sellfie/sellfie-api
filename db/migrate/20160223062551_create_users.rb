class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.string :confirmation_token
      t.datetime :confirmed_at

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :confirmation_token,   unique: true
  end
end
