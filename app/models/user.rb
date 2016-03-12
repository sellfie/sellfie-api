class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable,
          :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  # Associations
  has_many :products, :class_name => 'Product', :primary_key => 'id',
    :foreign_key => 'seller_id'
  has_many :purchases, :class_name => 'Purchase', :primary_key => 'id',
    :foreign_key => 'buyer_id'
end
