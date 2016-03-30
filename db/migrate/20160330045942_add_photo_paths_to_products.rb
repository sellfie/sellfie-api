class AddPhotoPathsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :photo_paths, :text, :array => true, :default => []
  end
end
