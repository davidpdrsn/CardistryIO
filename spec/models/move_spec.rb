require "rails_helper"

describe Move do
  it { should belong_to :user }
  it { should have_many :appearances }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  it "destroys appearances when its destroyed" do
    move = create :move
    create :appearance, move: move

    move.destroy

    expect(Appearance.count).to eq 0
  end
end
