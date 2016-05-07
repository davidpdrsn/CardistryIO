class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.foreign_key
    "#{name.downcase}_id"
  end
end
