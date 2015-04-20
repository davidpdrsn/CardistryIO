require "rails_helper"

describe TimeFormatter do
  it "formats times" do
    expect(TimeFormatter.new(10, 21).format).to eq "10:21"
    expect(TimeFormatter.new(1, 21).format).to eq "01:21"
    expect(TimeFormatter.new(1, 1).format).to eq "01:01"
  end
end
