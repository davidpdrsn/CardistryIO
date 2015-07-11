class StringWithPlaceholders
  pattr_initialize :str

  def expand(args = {})
    args.each do |key, value|
      needle = "{{#{key}}}"

      if str.include?(needle)
        str.gsub!(needle, value.call)
      end
    end

    str
  end
end
