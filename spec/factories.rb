FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "bob-#{n}@example.com" }
    password "secret"
  end

  factory :move do
    name "Sybil"
    user
  end

  factory :video do
    name "Classic"
    description "A video I made"
    url "https://www.youtube.com/watch?v=W799NKLEz8s"
  end
end
