require "rails_helper"

describe CompositeObserver do
  it "delegates save to all the observers" do
    model = double("model")
    one = stubbed_observer(model)
    two = stubbed_observer(model)

    observer = CompositeObserver.new([one, two])
    observer.save(model)

    expect(one).to have_received(:save).with(model)
    expect(two).to have_received(:save).with(model)
  end

  def stubbed_observer(model)
    observer = double("observer")
    allow(observer).to receive(:save).with(model)
    observer
  end
end
