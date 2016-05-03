class Product < ActiveRecord::Base
  #
  # Constants
  #
  VALUE_CONDITION_MIN = 1
  VALUE_CONDITION_MAX = 10

  #
  # Associations
  #
  belongs_to :category
  belongs_to :seller, :class_name => 'User', :foreign_key => 'seller_id'
  has_many :product_photos

  #
  # Validations
  #
  validates_presence_of :name, :seller
  validates :condition, presence: true, :numericality => {
    only_integer: true,
    greater_than_or_equal_to: VALUE_CONDITION_MIN,
    less_than_or_equal_to: VALUE_CONDITION_MAX
  }
  validates :price, presence: true, :numericality => {
    greater_than_or_equal_to: 0
  }
  validates :shipping_fee, :numericality => {
    greater_than_or_equal_to: 0
  }

end
