class SwapsEnv
  def swap_for(temp_env)
    original_env = Rails.env
    Rails.env = temp_env
    yield
  ensure
    Rails.env = original_env
  end
end
