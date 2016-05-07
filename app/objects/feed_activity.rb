class FeedActivity < SimpleDelegator
  def name
    subject.name
  end

  def text
    name
  end
end
