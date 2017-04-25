class Level < ApplicationRecord
  has_many :candidates
  has_many :responses

end
