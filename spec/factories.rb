FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "kevin-#{n}@example.com" }
    password "secret"
    sequence(:username) { |n| "visualmadness-#{n}" }
    sequence(:instagram_username) { |n| "kevho-#{n}" }
  end

  factory :comment do
    content "Not bad"
    user
    commentable_id { |comment| create(:move).id }
    commentable_type "Move"
  end

  factory :move do
    sequence(:name) { |n| "Sybil #{n}" }
    user
  end

  factory :video do
    sequence(:name) { |n| "Classic #{n}" }
    description "A video I made"
    url "https://www.youtube.com/watch?v=W799NKLEz8s"
    user
    approved true
  end

  factory :appearance do
    video
    move
    minutes 1
    seconds 2
  end

  factory :notification do
    user
    association :type, factory: :notification_type
    association :subject, factory: :video
    association :actor, factory: :user
  end

  factory :notification_type do
    name "factory-notification-type"
  end
end
