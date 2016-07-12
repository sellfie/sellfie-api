class AddAttributesToUser < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :nationality, :string
    add_column :users, :age, :integer
    add_column :users, :phone, :string
  end
end
