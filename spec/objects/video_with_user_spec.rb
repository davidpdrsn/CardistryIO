require "rails_helper"

describe MoveWithUser do
  subject(:video) { described_class.new(video: raw_video, user: user) }

  let(:raw_video) { instance_double("video", name: "Sybil") }
  let(:user) { instance_double("user", username: "david") }

  describe "#author" do
    subject(:author) { video.author }

    it { is_expected.to eq "david" }
  end
end
