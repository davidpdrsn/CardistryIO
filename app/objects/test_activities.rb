class TestActivities
  pattr_initialize :user

  def video
    TestData.ensure_not_production_env!
    create!(subject: Video.order('RANDOM()').first!)
  end

  def move
    TestData.ensure_not_production_env!
    create!(subject: Move.order('RANDOM()').first!)
  end

  private

  def create!(subject:)
    Activity.create!(
      user: user,
      subject: subject,
    )
  end
end
