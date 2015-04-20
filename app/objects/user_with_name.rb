class UserWithName < SimpleDelegator
  def name
    if [first_name, last_name].all?(&:present?)
      "#{first_name} #{last_name}"
    else
      email
    end
  end
end
