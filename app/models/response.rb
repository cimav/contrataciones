class Response < ApplicationRecord
  audited
  belongs_to :candidate
  belongs_to :user
  belongs_to :level
  after_save :set_level


  def set_level
    candidate = Candidate.find(self.candidate.id)
    responses = Response.where(candidate: candidate)
    if responses.size == User.where(user_type: User::COMMITTEE).size
      # Aquí se guardarán los niveles elegidos por cada miembro
      levels = []
      responses.each do |response|
      levels.push(response[:level_id])
      end
      # Se crea un hash para obtener el nivel más votado
      levels_hash = {}
      levels.each do |level|
        if levels_hash[level].nil?
          levels_hash[level] = 1
        else
          levels_hash[level] += 1
        end
      end
      # Asignar el nivel más votado
      more_vote = levels_hash.max_by{|k,v| v}
      members = User.where(user_type: User::COMMITTEE).size
      if more_vote[1] > members/2
        candidate.level = Level.find(more_vote[0])
        candidate.status = Candidate::FINALIZED
        candidate.decision_type = Candidate::UNANIMITY
        candidate.save!
      else
        candidate.status = Candidate::DISAGREE
        candidate.save!
      end

    end
  end

end
