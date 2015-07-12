class MoveSerializer < ActiveModel::Serializer
  attributes(
    :name
  )

  has_many :credits

  def credits
    object.creditted_users.map do |user|
      UserSerializer.new(user, root: false).as_json
    end
  end
end
