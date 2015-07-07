class UserWithName < SimpleDelegator
  def name_for_select
    username
  end
end
