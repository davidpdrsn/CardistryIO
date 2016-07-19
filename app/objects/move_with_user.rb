class MoveWithUser < ActiveRecordDecorator

  attr_accessor :move, :user

  def initialize(move:, user:)
    super(move)
    @move = move
    @user = user
  end

  def author
    user.username
  end

  def additional_attributes
    {
      'creditted-users' => move.creditted_users.count,
      'appearances' => move.appearances.count,
      'average-ratings' => move.average_rating,
      'total-ratings' => ratings.count,
    }
  end
end
