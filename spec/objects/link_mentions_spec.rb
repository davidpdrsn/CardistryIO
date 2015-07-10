require "rails_helper"

describe LinkMentions do
  it "turns @mentions into links" do
    bob = create :user, username: "bob"
    html = LinkMentions.new("hi @bob hi").link_mentions

    expect(Capybara.string(html)).to have_link "@bob"
  end

  it "works with ? after the @mention" do
    bob = create :user, username: "bob"
    html = LinkMentions.new("hi @bob? hi").link_mentions

    expect(Capybara.string(html)).to have_link "@bob"
    expect(html).to include("/users/#{bob.to_param}")
  end

  it "works with ! after the @mention" do
    bob = create :user, username: "bob"
    html = LinkMentions.new("hi @bob! hi").link_mentions

    expect(Capybara.string(html)).to have_link "@bob"
    expect(html).to include("/users/#{bob.to_param}")
    expect(html).not_to include("!<")
  end

  it "works with the @mention being the last word" do
    bob = create :user, username: "bob"
    html = LinkMentions.new("hi @bob").link_mentions

    expect(Capybara.string(html)).to have_link "@bob"
    expect(html).to include("/users/#{bob.to_param}")
  end

  it "works with the mention the first word" do
    bob = create :user, username: "bob"
    html = LinkMentions.new("@bob hi").link_mentions

    expect(Capybara.string(html)).to have_link "@bob"
    expect(html).to include("/users/#{bob.to_param}")
  end

  it "works with the mention the only word" do
    bob = create :user, username: "bob"
    html = LinkMentions.new("@bob").link_mentions

    expect(Capybara.string(html)).to have_link "@bob"
    expect(html).to include("/users/#{bob.to_param}")
  end

  it "ignores users that don't exist" do
    html = LinkMentions.new("@alice").link_mentions

    expect(Capybara.string(html)).not_to have_link "@alice"
    expect(html).not_to include("href")
  end

  it "works with stuff in front of the mention" do
    bob = create :user, username: "bob"
    html = LinkMentions.new("!@bob").link_mentions

    expect(Capybara.string(html)).to have_link "@bob"
    expect(html).to include("/users/#{bob.to_param}")
    expect(html).to include("!<")
  end

  it "works stuff before and after the mention" do
    bob = create :user, username: "bob"
    html = LinkMentions.new("!!@bob,").link_mentions

    expect(Capybara.string(html)).to have_link "@bob"
    expect(html).to include("/users/#{bob.to_param}")
    expect(html).to include("!!<")
    expect(html).to include(">,")
  end

  it "works with multiple mentions" do
    bob = create :user, username: "bob"
    alice = create :user, username: "alice"
    html = LinkMentions.new("@bob, @alice").link_mentions

    expect(Capybara.string(html)).to have_link "@bob"
    expect(Capybara.string(html)).to have_link "@alice"
    expect(html).to include("/users/#{bob.to_param}")
    expect(html).to include("/users/#{alice.to_param}")
  end
end
