module LinkMentionsHelper
  def link_mentions(str)
    LinkMentions.new(str).link_mentions
  end
end
