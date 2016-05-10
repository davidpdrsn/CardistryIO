class CreditableUsers
  pattr_initialize [:current_user!, :creditable!]

  def find_users
    User
      .where.not(id: current_user.id)
      .where.not(id: creditable.credits.pluck(:user_id))
      .where.not(id: creditable.user_id)
  end
end
