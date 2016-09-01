after "development:users" do
  users = User.all
  video_types = %w(performance tutorial move_showcase other)
  20.times do
    FactoryGirl.create :move, user: users.sample
    FactoryGirl.create :move, user: users.sample, idea: true
    FactoryGirl.create :video, user: users.sample, video_type: video_types.sample
  end
end
