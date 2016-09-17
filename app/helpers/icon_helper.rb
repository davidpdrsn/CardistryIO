module IconHelper
  def icon(name, options = {})
    icon_name = if name.include?("ion-")
                  name
                else
                  "ion-#{name}"
                end

    options[:class] = "#{options[:class]} icon #{icon_name}"

    content_tag :i, nil, options
  end
end
