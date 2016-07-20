require "rails_helper"

describe MoveWithUser do
  subject(:move) { described_class.new(move: raw_move, user: user) }

  let(:raw_move) { instance_double('move', name: 'Sybil', average_rating: 5.7, ratings: [5,6]) }
  let(:user) { instance_double('user', username: 'david') }

  describe '#author' do
    subject(:author) { move.author }

    it { is_expected.to eq 'david' }
  end

  describe '#additional_attributes' do
    subject { move.additional_attributes }

    let(:expected_attributes) do
      {
        'average-ratings' => 5.7,
        'total-ratings' => 2
      }
    end

    it { is_expected.to include expected_attributes }
  end
end
