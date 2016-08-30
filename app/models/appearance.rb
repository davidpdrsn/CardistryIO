class Appearance < ApplicationRecord
  belongs_to :video
  belongs_to :move

  validates :move_id, presence: true
  validates :video_id, presence: true

  delegate :name, to: :move, prefix: true
  delegate :name, to: :video, prefix: true

  def value_for_sort
    [minutes, seconds]
  end
end
