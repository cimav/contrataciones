class Candidate < ApplicationRecord
  belongs_to :department
  belongs_to :level
  has_many :responses
end
