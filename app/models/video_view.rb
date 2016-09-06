class VideoView < ApplicationRecord
  belongs_to :user
  belongs_to :video, touch: true
end
