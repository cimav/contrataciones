class Level < ApplicationRecord
  has_many :candidates
  has_many :responses

  TECHNICAL = 1
  INVESTIGATION = 2

  WITHOUT_LEVEL = 1
end
