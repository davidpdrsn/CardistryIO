class SingleCreditPerUser < ActiveModel::Validator
  def validate(record)
    creditted_users = (record.creditable.credits + [record]).map(&:user)

    if duplicates?(creditted_users)
      record.errors.add(:base, "Cannot credit the same user more than once")
    end
  end

  private

  def duplicates?(array)
    array.any? { |object| array.count(object) > 1 }
  end
end
