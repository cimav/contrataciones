class Response < ApplicationRecord
  belongs_to :candidate
  belongs_to :user
  belongs_to :level
end
