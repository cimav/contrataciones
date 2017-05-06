class Candidate < ApplicationRecord
  belongs_to :department
  belongs_to :level
  has_many :responses
  mount_uploader :curriculum, CurriculumUploader

  WAITING = 1
  FINALIZED = 2

end
