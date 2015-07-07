class MoveWithUser < SimpleDelegator
  def initialize(move:, user:)
    super(move)
    @move = move
    @user = user
  end

  def name
    "#{@move.name} by #{@user.username}"
  end
end
