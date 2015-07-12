class AddsCredits
  pattr_initialize :model

  def add_credits(credit_params)
    return unless credit_params.present?

    model.credits = build_credits(credit_params)
  end

  def update_credits(credit_params)
    return unless credit_params.present?

    credit_params.each do |username|
      user = User.find_by(username: username)
      model.credits.where(user: user).each(&:destroy!)
    end
    add_credits(credit_params)
  end

  # private

  def build_credits(credit_params)
    credit_params.each_with_object([]) do |username, acc|
      user = User.find_by!(username: username)
      acc << Credit.create(user: user, creditable: model)
    end
  end
end
