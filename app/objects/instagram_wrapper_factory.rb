class InstagramWrapperFactory
  def self.call
    if Rails.env.test?
      InstagramIOFake
    else
      InstagramIO
    end
  end
end
