require "rails_helper"

describe StringWithPlaceholders do
  it "can be turned into a normal string" do
    str = StringWithPlaceholders.new("hi")

    expect(str.expand({})).to eq "hi"
  end

  it "expands placeholders" do
    str = StringWithPlaceholders.new("name: {{name}}")

    expect(str.expand(name: ->() { "bob" })).to eq "name: bob"
  end

  it "doesn't call the block unless there is a matching key" do
    str = StringWithPlaceholders.new("lol")

    expect do
      str.expand(name: ->() { fail })
    end.to_not raise_error
  end
end
