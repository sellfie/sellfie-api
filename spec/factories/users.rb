FactoryGirl.define do
  factory :user do
    email 'me@maianhvu.com'
    password 'secretpassword'
    confirmed_at { 1.day.ago }

    trait :unconfirmed do
      confirmed_at nil
    end
  end
end
