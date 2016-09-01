after "development:moves" do
  User.all.each do |user|
    test_activities_creator = TestActivities.new(user)
    test_activities_creator.video
    test_activities_creator.move
  end
end
