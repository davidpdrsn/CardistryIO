class StringWithPlaceholders
  pattr_initialize :str

  def expand(args = {})
    args.each do |key, value|
      needle = "{{#{key}}}"

      if str.include?(needle)
        str.gsub!(needle, get_value(value))
      end
    end

    str
  end

  private

  def get_value(value)
    if value.respond_to?(:call)
      value.call
    else
      value
    end
  end
end
