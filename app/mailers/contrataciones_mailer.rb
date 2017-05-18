class ContratacionesMailer < ApplicationMailer
	def new_candidate(candidate)
		@candidate = candidate

		@from = "Notificaciones CIMAV <notificaciones@cimav.edu.mx>"
		@to = User.where(user_type: User::COMMITTEE).map(&:email).join(",")

		unless candidate.curriculum.blank?
			attachments[File.basename(@candidate.curriculum.path)] = File.read(@candidate.curriculum.path)
		end

		mail(to: @to,  :from => @from, subject: "[Contrataciones] Nivel para #{@candidate.name}")
	end
end
