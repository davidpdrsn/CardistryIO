require "rails_helper"

describe VideoWithUser do
  subject(:video) { described_class.new(video: raw_video, user: user) }

  let(:raw_video) { instance_double("video", name: "Sybil") }
  let(:user) { instance_double("user", username: "david") }

  describe "#author" do
    subject { video.author }

    it { is_expected.to eq "david" }
  end

  describe "#name" do
    subject { video.name }

    it { is_expected.to eq "Sybil" }
  end

  describe "#additional_attributes" do
    subject { video.additional_attributes }

    let(:raw_video) { instance_double("video", unique_views_count: 2222, average_rating: 5.6) }
    let(:expected_attributes) do
      {
        'views' => 2222,
        'comments' => 5,
        'average-ratings' => 5.6,
        'total-ratings' => 8
      }
    end

    before do
      allow(raw_video).to receive_message_chain(:comments, :count).and_return(5)
      allow(raw_video).to receive_message_chain(:ratings, :count).and_return(8)
    end

    it { is_expected.to include expected_attributes }
  end
end
