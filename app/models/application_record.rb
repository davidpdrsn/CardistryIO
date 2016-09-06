class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.foreign_key
    "#{name.downcase}_id"
  end

  def foreign_key
    self.class.foreign_key
  end

  def self.find_ordered_by_ids(ids)
    order_by = ["CASE"]
    ids.each_with_index.map do |id, index|
      order_by << "WHEN #{table_name}.id='#{id}' THEN #{index}"
    end
    order_by << "END"
    order(order_by.join(" "))
  end

  def self.touch_on_save(method)
    touch_association = ->() do
      association = reload.send(method)
      return unless association.present?
      if association.respond_to?(:each)
        association.each(&:touch)
      else
        association.touch
      end
      reload
    end

    after_touch(&touch_association)
    after_save(&touch_association)
  end
end
