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
end
