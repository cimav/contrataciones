class User < ApplicationRecord
  audited
  belongs_to :department
  has_many :responses, dependent: :destroy

  ADMIN = 1
  COMMITTEE = 2
  SUPER_USER = 1000

  TYPES = {
      ADMIN => 'Administrador',
      COMMITTEE => 'Miembro del comité',
      SUPER_USER => 'Super Usuario'
  }

  def get_type
    TYPES[user_type]
  end
end
