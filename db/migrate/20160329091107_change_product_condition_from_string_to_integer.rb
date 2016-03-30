class ChangeProductConditionFromStringToInteger < ActiveRecord::Migration
  def change
    connection.execute(
    <<-SQL
    ALTER TABLE products ALTER COLUMN condition TYPE integer USING (1)
    SQL
    )
  end
end
