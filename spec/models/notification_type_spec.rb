require "rails_helper"

describe NotificationType do
  it { should have_many :notifications }

  [
    :comment,
    :video_approved,
    :new_follower,
    :video_shared,
    :mentioned,
  ].each do |type_name|
    describe ".#{type_name}" do
      it "returns a #{type_name} type" do
        type = NotificationType.send(type_name)
        expect(type.name).to eq type_name.to_s
      end

      it "doesn't create the same type more than once" do
        2.times do
          NotificationType.send(type_name)
        end

        expect(NotificationType.count).to eq 1
      end
    end
  end
end
