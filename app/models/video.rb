class Video < ActiveRecord::Base
  validates :name, presence: true
  validates :url, presence: true
end
