class TestNotifications
  pattr_initialize :user

  def comment_on_video
    comment_on(video)
  end

  def comment_on_move
    comment_on(move)
  end

  def video_approved
    create!(subject: video, type: :video_approved)
  end

  def new_follower
    relationship = begin
                     actor.relationships.find_by!(followee: user)
                   rescue ActiveRecord::RecordNotFound
                     actor.follow!(user)
                     retry
                   end
    create!(subject: relationship, type: :new_follower)
  end

  def video_shared
    create!(subject: video, type: :video_shared)
  end

  def mentioned
    create!(subject: video, type: :mentioned)
  end

  def new_credit
    create!(subject: video, type: :new_credit)
  end

  private

  def comment_on(model)
    create!(subject: model, type: :comment)
  end

  def create!(subject:, type:)
    TestData.ensure_not_production_env!

    Notification.create!(
      user: user,
      actor: actor,
      subject: subject,
      notification_type: type,
    )
  end

  def video
    Video.first!
  end

  def move
    Move.first!
  end

  def actor
    User.where.not(id: user.id).first!
  end
end
