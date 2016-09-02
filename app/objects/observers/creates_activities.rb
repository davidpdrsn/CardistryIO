# An observer that will create activities for the related model when it is saved
module Observers
  class CreatesActivities
    def save(model)
      ::Activity.create(
        subject: model,
        user: model.user,
      )
    end

    def save!(model)
      ::Activity.create!(
        subject: model,
        user: model.user,
      )
    end
  end
end
