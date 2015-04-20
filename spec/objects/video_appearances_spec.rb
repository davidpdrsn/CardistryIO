require "rails_helper"

describe VideoAppearances do
  it "makes move appearances" do
    video = create :video
    create :move, name: "Sybil"
    create :move, name: "Mocking Bird"
    move_names = ["Sybil", "Mocking Bird"]
    minutes = [1,2]
    seconds = [0, 20]

    video_appearances = VideoAppearances.new(
      video: video,
      move_names: move_names,
      minutes: minutes,
      seconds: seconds,
    )

    result = video_appearances.save

    appearances = Appearance.all
    expect(result).to eq true
    expect(appearances.map(&:move_name)).to eq ["Sybil",
                                                "Mocking Bird"]
    expect(appearances.map(&:minutes)).to eq [1, 2]
    expect(appearances.map(&:seconds)).to eq [0, 20]
  end

  it "doesn't save if some of the moves don't exist" do
    video = create :video
    create :move, name: "Sybil"
    move_names = ["Sybil", "Mocking Bird"]
    minutes = [1,2]
    seconds = [0, 20]

    video_appearances = VideoAppearances.new(
      video: video,
      move_names: move_names,
      minutes: minutes,
      seconds: seconds,
    )

    result = video_appearances.save

    appearances = Appearance.all
    expect(result).to eq false
    expect(appearances.count).to eq 0
  end

  it "overrides previous move appearances" do
    video = create :video
    create :move, name: "Sybil"
    create :move, name: "Mocking Bird"

    VideoAppearances.new(
      video: video,
      move_names: ["Sybil"],
      minutes: [1],
      seconds: [0],
    ).save

    result = VideoAppearances.new(
      video: video,
      move_names: ["Mocking Bird"],
      minutes: [2],
      seconds: [10],
    ).save

    appearances = Appearance.all
    expect(appearances.map(&:move_name)).to eq ["Mocking Bird"]
    expect(appearances.map(&:minutes)).to eq [2]
    expect(appearances.map(&:seconds)).to eq [10]
  end
end
