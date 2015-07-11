class LinkMentions
  def initialize(str)
    @str = ERB::Util.html_escape(str)
    @users_mentioned = []
  end

  def link_mentions
    html = transform_words do |word|
      if is_mention?(word)
        make_into_link_and_track_mentioned_users(word)
      else
        word
      end
    end.html_safe

    HtmlWithMentions.new(html, users_mentioned)
  end

  private

  HtmlWithMentions = Struct.new(:html, :users_mentioned)

  def transform_words
    str.split(" ").map do |word|
      yield word
    end.join(" ")
  end

  def is_mention?(word)
    word.include?("@")
  end

  def make_into_link_and_track_mentioned_users(word)
    match = word.match(/(.*?)@(#{User::USERNAME_REGEX})(.*)/)
    start = match[1]
    username = match[2]
    rest = match[3]
    user = User.find_by(username: username)

    if user.present?
      users_mentioned << user
      %{#{start}<a href="/users/#{user.to_param}">@#{username}</a>#{rest}}
    else
      word
    end
  end

  attr_reader :str, :users_mentioned
end
