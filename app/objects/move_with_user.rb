class MoveWithUser < ActiveRecordDecorator
  def initialize(move:, user:)
    super(move)
    @move = move
    @user = user
  end

  def author
    @user.username
  end

  def additional_attributes
    {
      creditted_users: @move.creditted_users,
      appearances: @move.appearances,
    }
  end
end
