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
    create!(subject: actor, type: :new_follower)
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
    ensure_development_env!

    Notification.create!(
      user: user,
      actor: actor,
      subject: subject,
      notification_type: type,
    )
  end

  def ensure_development_env!
    raise "Only works in development and test" if Rails.env.production?
  end

  def video
    first!(Video)
  end

  def move
    first!(Move)
  end

  def actor
    first!(
      User.where.not(id: user.id),
      error_message: "There most be at least one other user",
    )
  end

  def first!(relation, error_message: nil)
    error_message ||=
      "There must be at least one #{relation.table_name.singularize}"

    relation.all.first || raise(error_message)
  end
end
