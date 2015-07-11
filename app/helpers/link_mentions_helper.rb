module LinkMentionsHelper
  def link_mentions(str)
    return str if str.blank?
    LinkMentions.new(str).link_mentions.html
  end
end
