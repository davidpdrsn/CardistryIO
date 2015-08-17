require "rails_helper"

describe ActivityObserver do
  it "creates a new activity for the model" do
    model = build_stubbed(:move)
    user = instance_double("User")
    allow(model).to receive(:user).and_return(user)
    observer = ActivityObserver.new

    allow(Activity).to receive(:create).with(
      subject: model,
      user: user
    )

    observer.save(model)

    expect(Activity).to have_received(:create).with(
      subject: model,
      user: user
    )
  end
end
