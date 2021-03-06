FactoryGirl.define do
  factory :product do
    sequence(:name) { |n| "Product Number #{n}" }
    description "An awesome product"
    condition 10
    price 10.0
    shipping_fee 2.5
    association :seller, factory: [ :user, :vendor ]

    trait :vendorless do
      seller_id nil
    end

    trait :uncategorized do
      category nil
    end
  end
end
