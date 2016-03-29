class ChangeProductConditionFromStringToInteger < ActiveRecord::Migration
  def change
    change_column :products, :condition, :integer, :default => 1
  end
end
