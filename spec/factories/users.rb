FactoryGirl.define do
  factory :user do
    email 'me@maianhvu.com'
    password 'secretpassword'
    confirmed_at { 1.day.ago }

    trait :unconfirmed do
      confirmed_at nil
    end

    trait :vendor do
      email 'vendor@example.com'
      password 'tradesecret'
      confirmed_at { 2.years.ago }
    end
  end
end
