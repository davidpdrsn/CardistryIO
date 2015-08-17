class ActivityObserver
  def save(model)
    Activity.create(
      subject: model,
      user: model.user,
    )
  end

  def save!(model)
    Activity.create!(
      subject: model,
      user: model.user,
    )
  end
end
