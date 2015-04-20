class EmbeddableVideo < SimpleDelegator
  def url
    __getobj__.url.sub("watch?v=", "embed/")
  end
end
