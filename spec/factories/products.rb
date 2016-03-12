FactoryGirl.define do
  factory :product do
    name "MyString"
    description "MyString"
    condition "MyString"
    price 1.5
    shipping_fee 1.5
    category nil
    user nil
  end
end
