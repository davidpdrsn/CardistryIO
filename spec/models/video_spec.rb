require "rails_helper"

describe Video do
  it { should belong_to :user }
  it { should have_many :appearances }
  it { should have_many :comments }
  it { should have_many :sharings }
  it { should have_many :ratings }
  it { should have_many :credits }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
  it { should validate_presence_of :url }
  it { should validate_presence_of :video_type }

  it "is not approved by default" do
    video = Video.new

    expect(video.approved?).to eq false
  end

  describe "#unapproved" do
    it "returns the unapproved videos" do
      create :video, approved: true
      video = create :video, approved: false

      expect(Video.unapproved).to eq [video]
    end
  end

  describe "#approve!" do
    it "approves a video" do
      video = build :video, approved: false
      video.approve!
      expect(video.approved?).to eq true
    end
  end

  it "destroys appearances when its destroyed" do
    video = create :video
    create :appearance, video: video

    video.destroy

    expect(Appearance.count).to eq 0
  end

  describe ".approved" do
    it "returns all approved videos" do
      video = create :video, approved: true
      create :video, approved: false

      expect(Video.approved).to eq [video]
    end
  end

  describe ".all_public" do
    it "returns approved and non-private videos" do
      video = create :video, approved: true
      create :video, approved: true, private: true
      create :video, approved: false

      expect(Video.all_public).to eq [video]
    end
  end

  describe "#from_instagram?" do
    it "returns true if the video is from instagram" do
      url = "https://scontent.cdninstagram.com/hphotos-xaf1/t50.2886-16/11243245_1599951966956675_1378908578_s.mp4"

      video = Video.new(url: url)

      expect(video.from_instagram?).to eq true
    end

    it "returns false if it ins't from instagram" do
      url = "https://www.youtube.com/watch?v=p2H5YVfZVFw"

      video = Video.new(url: url)

      expect(video.from_instagram?).to eq false
    end
  end

  describe "validating video host" do
    describe "when it is valid" do
      it "instagram" do
        expect_valid_host("https://www.instagram.com/watch?v=W799NKLEz8s")
      end

      it "youtube" do
        expect_valid_host("https://www.youtube.com/watch?v=W799NKLEz8s")
      end

      it "vimeo" do
        expect_valid_host("https://www.vimeo.com/watch?v=W799NKLEz8s")
      end
    end

    it "not valid otherwise" do
      video = build :video, url: "example.com"
      expect(video).not_to be_valid
    end

    def expect_valid_host(url)
      video = build :video, url: url
      expect(video).to be_valid
    end
  end

  describe "#creditted_users" do
    it "returns the users creditted for the video" do
      video = create :video
      bob = create :user
      alice = create :user
      Credit.create!(creditable: video, user: bob)

      expect(video.creditted_users).to eq [bob]
    end
  end

  it "deletes its activites when it is deleted" do
    video = create :video
    Activity.create!(subject: video, user: video.user)

    expect do
      video.destroy!
    end.to change { Activity.count }.from(1).to(0)
  end
end
