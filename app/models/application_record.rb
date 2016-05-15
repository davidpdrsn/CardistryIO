class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.foreign_key
    "#{name.downcase}_id"
  end

  def foreign_key
    self.class.foreign_key
  end
end
