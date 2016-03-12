class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :seller, :class_name => 'User', :foreign_key => 'seller_id'
end
