class UserWithName < SimpleDelegator
  def name
    if [first_name, last_name].all?(&:present?)
      "#{first_name} #{last_name}"
    else
      email
    end
  end

  def name_for_select
    "#{name} (#{username})"
  end
end
