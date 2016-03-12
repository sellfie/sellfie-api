FactoryGirl.define do
  factory :product do
    sequence(:name) { |n| "Product ##{n}" }
    description "An awesome product"
    condition "good"
    price 10.0
    shipping_fee 2.5
    association :seller, factory: :vendor
  end
end
