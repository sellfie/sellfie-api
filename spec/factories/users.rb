FactoryGirl.define do
  factory :user do
    email 'me@maianhvu.com'
    username 'maianhvu'
    password 'secretpassword'
    confirmed_at { 1.day.ago }
    name 'Mai Anh Vu'
    gender 'male'
    nationality 'Vietnamese'
    age 22
    address '9C Yuan Ching Road, Singapore 618645'
    phone '+65 8464 0163'

    trait :unconfirmed do
      confirmed_at nil
    end

    trait :vendor do
      email 'vendor@example.com'
      username 'vendor'
      password 'tradesecret'
      confirmed_at { 2.years.ago }
    end

    trait :generic do
      sequence(:email) { |n| "person#{n}@example.com" }
      sequence(:username) { |n| "user#{n}" }
    end

    trait :minimal do
      age nil
      address nil
      phone nil
    end
  end
end
