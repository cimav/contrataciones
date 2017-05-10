class Candidate < ApplicationRecord
  belongs_to :department
  belongs_to :level
  has_many :responses, dependent: :destroy
  mount_uploader :curriculum, CurriculumUploader

  UNANIMITY = 1
  NOT_COMMITTEE = 2
  REJECTED = 3

  WAITING = 1
  FINALIZED = 2
  DISAGREE = 3

  LEVEL_TYPES = {
      UNANIMITY => "Decisión unánime",
      NOT_COMMITTEE => "Enviado a comité",
      REJECTED => "Rechazado"
  }

  def get_decision_type
    LEVEL_TYPES[decision_type]
  end

end
