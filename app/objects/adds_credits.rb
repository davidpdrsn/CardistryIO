class AddsCredits
  pattr_initialize :model

  def add_credits(credit_params)
    return unless credit_params.present?

    model.credits = build_credits(credit_params)
  end

  private

  def build_credits(credit_params)
    credit_params.each_with_object([]) do |username, acc|
      user = User.find_by!(username: username)
      acc << Credit.create(user: user, creditable: model)
    end
  end
end
