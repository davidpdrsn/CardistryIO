require "rails_helper"

describe ActiveRecordDecorator do
  it "acts as a decorator" do
    decorator = Class.new(ActiveRecordDecorator) do
      def foo
        :foo
      end
    end

    user = decorator.new(create(:user, username: "Bob"))

    expect(user.foo).to eq :foo
    expect(user.username).to eq "Bob"
  end

  it "can be assigned as associations and queries" do
    decorator = Class.new(ActiveRecordDecorator)

    raw_user = create :user
    user = decorator.new(raw_user)
    notification = create :notification, user: user

    expect(notification.user).to eq raw_user
    expect(Notification.where(user: user)).to eq [notification]
  end
end
