require "rails_helper"

describe DelegationChain do
  it "delegates methods to the first object that responds to it" do
    probe = double("probe")
    one = double("one", foo: probe)
    two = double("two", bar: probe)

    chain = DelegationChain.new(one, two)

    expect(chain.foo).to eq probe
    expect(chain.bar).to eq probe
  end

  it "handles respond_to?" do
    probe = double("probe")
    one = double("one", foo: probe)
    two = double("two", bar: probe)

    chain = DelegationChain.new(one, two)

    expect(chain.respond_to?(:foo)).to eq true
    expect(chain.respond_to?(:bar)).to eq true
    expect(chain.respond_to?(:laksjdlfk)).to eq false
  end
end
