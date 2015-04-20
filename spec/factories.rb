FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "bob-#{n}@example.com" }
    password "secret"
  end

  factory :move do
    name "Sybil"
    user
  end
end
