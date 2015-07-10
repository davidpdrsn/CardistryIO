class LinkMentions
  def initialize(str)
    @str = ERB::Util.html_escape(str)
  end

  def link_mentions
    transform_words do |word|
      if is_mention?(word)
        make_into_link(word)
      else
        word
      end
    end.html_safe
  end

  private

  def transform_words
    str.split(" ").map do |word|
      yield word
    end.join(" ")
  end

  def is_mention?(word)
    word.include?("@")
  end

  def make_into_link(word)
    match = word.match(/(.*?)@(#{User::USERNAME_REGEX})(.*)/)
    start = match[1]
    username = match[2]
    rest = match[3]
    user = User.find_by(username: username)

    if user.present?
      %{#{start}<a href='/users/#{user.to_param}'>@#{username}</a>#{rest}}
    else
      word
    end
  end

  attr_reader :str
end
