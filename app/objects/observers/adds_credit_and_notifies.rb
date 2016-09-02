# Observer that calls ::AddsCredits when models are being saved
module Observers
  class AddsCreditAndNotifies
    pattr_initialize :params, :current_user

    def save!(move)
      find_users_with_credits_for(move, then: :add_credits)
    end

    def update!(move, _)
      find_users_with_credits_for(move, then: :update_credits)
    end

    private

    def find_users_with_credits_for(move, options)
      method_name = options.fetch(:then)
      users = ::AddsCredits.new(move).public_send(method_name, params[:credits])
      notifier_users_of_new_credit(users, move)
    end

    def notifier_users_of_new_credit(users, move)
      users.each do |user|
        Notifier.new(user).new_credit(subject: move, actor: current_user)
      end
    end
  end
end
