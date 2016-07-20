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
      'average-ratings' => move.average_rating,
      'total-ratings' => move.ratings.count,
    }
  end
end
