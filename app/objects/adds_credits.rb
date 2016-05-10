class AddsCredits
  pattr_initialize :model

  def add_credits(credit_params)
    return [] unless credit_params.present?
    credits = build_credits(credit_params)
    model.credits = credits
    credits.map(&:user)
  end

  def update_credits(credit_params)
    credit_params ||= []
    new_credits = new_credited_users(credit_params)
    destroy_existing_credits(credit_params)
    add_credits(credit_params)
    new_credits
  end

  private

  def build_credits(credit_params)
    credit_params.each_with_object([]) do |username, acc|
      user = User.find_by!(username: username)
      if model.credits.where(user: user).blank?
        acc << model.credits.create(user: user)
      end
    end
  end

  def destroy_existing_credits(credit_params)
    model.credits.each(&:destroy!)
  end

  def new_credited_users(credit_params)
    before = model.credits.map(&:user)
    after = credit_params.map { |username| User.find_by!(username: username) }
    after - before
  end
end
