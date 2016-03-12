class Purchase < ActiveRecord::Base
  belongs_to :product
  belongs_to :buyer, :class_name => 'User', :foreign_key => 'buyer_id'
end
