FactoryGirl.define do
  factory :user do
    password "secret"
    country_code "DK"
    biography ""
    sequence(:username) { |n| "#{Faker::Internet.user_name(nil, %w(_-))}-#{n}" }
    sequence(:email) { |n| "#{username}@example.com" }
    sequence(:instagram_username) { |n| "ig-#{username}" }
    time_zone "Central Time (US & Canada)"

    trait :admin do
      admin true
    end
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
    sequence(:name) { |n| "#{Faker::App.name} #{rand(1000)}th" }
    user
    description "My favorite move"
  end

  factory :video do
    sequence(:name) { |n| "#{Faker::App.name} #{rand(1000)}" }
    description "A video I made"
    url "https://www.youtube.com/watch?v=W799NKLEz8s"
    user
    approved true

    trait :performance do
      video_type "performance"
    end

    trait :tutorial do
      video_type "tutorial"
    end

    trait :move_showcase do
      video_type "move_showcase"
    end

    trait :other do
      video_type "other"
    end
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
    association :subject, factory: :video
    association :actor, factory: :user
  end

  factory :sharing do
    user
    video
  end
end
