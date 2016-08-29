require "rails_helper"

describe LinkMentions do
  it "turns @mentions into links" do
    bob = create :user, username: "bob"
    html = html_with_mentions("hi @bob hi")

    expect_to_have_link html, "@bob"
  end

  it "works with ? after the @mention" do
    bob = create :user, username: "bob"
    html = html_with_mentions("hi @bob? hi")

    expect_to_have_link html, "@bob"
    expect(html).to include("/users/#{bob.to_param}")
  end

  it "works with ! after the @mention" do
    bob = create :user, username: "bob"
    html = html_with_mentions("hi @bob! hi")

    expect_to_have_link html, "@bob"
    expect(html).to include("/users/#{bob.to_param}")
    expect(html).not_to include("!<")
  end

  it "works with the @mention being the last word" do
    bob = create :user, username: "bob"
    html = html_with_mentions("hi @bob")

    expect_to_have_link html, "@bob"
    expect(html).to include("/users/#{bob.to_param}")
  end

  it "works with the mention the first word" do
    bob = create :user, username: "bob"
    html = html_with_mentions("@bob hi")

    expect_to_have_link html, "@bob"
    expect(html).to include("/users/#{bob.to_param}")
  end

  it "works with the mention the only word" do
    bob = create :user, username: "bob"
    html = html_with_mentions("@bob")

    expect_to_have_link html, "@bob"
    expect(html).to include("/users/#{bob.to_param}")
  end

  it "ignores users that don't exist" do
    html = html_with_mentions("@alice")

    expect_to_have_link html, "@alice", false
    expect(html).not_to include("href")
  end

  it "works with stuff in front of the mention" do
    bob = create :user, username: "bob"
    html = html_with_mentions("!@bob")

    expect_to_have_link html, "@bob"
    expect(html).to include("/users/#{bob.to_param}")
    expect(html).to include("!<")
  end

  it "works stuff before and after the mention" do
    bob = create :user, username: "bob"
    html = html_with_mentions("!!@bob,")

    expect_to_have_link html, "@bob"
    expect(html).to include("/users/#{bob.to_param}")
    expect(html).to include("!!<")
    expect(html).to include(">,")
  end

  it "works with multiple mentions" do
    bob = create :user, username: "bob"
    alice = create :user, username: "alice"
    html = html_with_mentions("@bob, @alice")

    expect_to_have_link html, "@bob"
    expect_to_have_link html, "@alice"
    expect(html).to include("/users/#{bob.to_param}")
    expect(html).to include("/users/#{alice.to_param}")
  end

  it "works with lonely @ signs" do
    html = html_with_mentions("hi @ 22:00")

    expect(html).to eq "hi @ 22:00"
  end

  it "maintains line breaks" do
    bob = create :user, username: "bob"
    alice = create :user, username: "alice"
    html = html_with_mentions("@bob\n@alice\r\nlol foo bar\nbaz")

    expect(html.lines.count).to eq 4
    expect(html.lines[2]).to eq "lol foo bar\n"
    expect_to_have_link html, "@bob"
    expect_to_have_link html, "@alice"
  end

  def expect_to_have_link(html, text, negate = true)
    if !negate
      expect(Capybara.string(html)).not_to have_link text
    else
      expect(Capybara.string(html)).to have_link text
    end
  end

  def html_with_mentions(text)
    LinkMentions.new(text).link_mentions.html
  end
end
