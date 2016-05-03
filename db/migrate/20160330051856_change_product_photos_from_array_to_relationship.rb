class ChangeProductPhotosFromArrayToRelationship < ActiveRecord::Migration
  def change
    create_table :product_photos do |t|
      t.string :path, null: false, default: ''
      t.references :product, index: true, foreign_key: true
    end

    Product.all.each do |product|
      product.photo_paths.each do |photo|
        ProductPhoto.create!(path: photo, product: product)
      end
    end

    remove_column :products, :photo_paths
  end
end
