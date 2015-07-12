class VideoSerializer < ActiveModel::Serializer
  attributes(
    :approved,
    :description,
    :instagram_id,
    :name,
    :private,
    :id,
    :url,
    :video_type,
  )

  has_one :user, serializer: UserSerializer
  has_many :credits

  def credits
    object.creditted_users.map do |user|
      UserSerializer.new(user, root: false).as_json
    end
  end
end
