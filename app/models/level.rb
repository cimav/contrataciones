class Level < ApplicationRecord
  has_many :candidates
  has_many :responses, dependent: :destroy

  TECHNICAL = 1
  INVESTIGATION = 2

  WITHOUT_LEVEL = 1
end
