class Department < ApplicationRecord
  has_many :users
  has_many :candidates
end
