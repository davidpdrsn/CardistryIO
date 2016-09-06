FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "kevin-#{n}@example.com" }
    password "secret"
    country_code "DK"
    biography ""
    sequence(:username) { |n| "visualmadness-#{n}" }
    sequence(:instagram_username) { |n| "kevho-#{n}" }
    time_zone "Central Time (US & Canada)"
  end

  factory :comment do
    content "Not bad"
    user
    commentable_id { |comment| create(:move).id }
    commentable_type "Move"
  end

  factory :credit do
    user
    creditable_id { |comment| create(:move).id }
    creditable_type "Move"
  end

  factory :rating do
    user
    rateable_id { |comment| create(:move).id }
    rateable_type "Move"
  end

  factory :move do
    sequence(:name) { |n| "Sybil #{n}th" }
    user
    description "My favorite move"
  end

  factory :video do
    sequence(:name) { |n| "Classic #{n}th" }
    description "A video I made"
    url "https://www.youtube.com/watch?v=W799NKLEz8s"
    user
    approved true
    video_type "performance"
  end

  factory :video_view do
    user
    video
  end

  factory :appearance do
    video
    move
    minutes 1
    seconds 2
  end

  factory :notification do
    user
    notification_type :comment
    association :subject, factory: :comment
    association :actor, factory: :user
  end

  factory :sharing do
    user
    video
  end

  factory :activity do
    user
    association :subject, factory: :video
  end
end
