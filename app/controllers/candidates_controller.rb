class CandidatesController < ApplicationController
  before_action :auth_required
  skip_before_action :verify_authenticity_token

  def index
    @candidates_waiting = Candidate.where(:status => Candidate::WAITING)
    @candidates_voted = Candidate.where.not(:status => Candidate::WAITING)

    if is_admin
      render :template => 'home/admin-index'
    else
      render :template => 'candidates/index'
    end
  end

  def new
    @candidate = Candidate.new
  end

  def create
    data = candidate_params
    data[:status] = Candidate::WAITING
    data[:level_id] = Level::WITHOUT_LEVEL
    @candidate = Candidate.new(data)
    if @candidate.save(data)
      #ContratacionesMailer.new_candidate(@candidate).deliver_now
      flash[:success] = "Se creó exitosamente al candidato: #{@candidate.name}"
      redirect_to @candidate
    else
      flash[:error] = "Error al crear candidato"
      flash[:alert] = @candidate.errors.full_messages[0]
      render :new
    end
  end

  def update
    @candidate = Candidate.find(params[:id])
    if @candidate.update(candidate_params)
      flash[:notice] = "Se actualizó al candidato: #{@candidate.name}"
      redirect_to @candidate
    else
      flash[:error] = "Error al actualizar candidato"
      flash[:alert] = @candidate.errors.full_messages[0]
      render :edit
    end
  end

  def show
    @candidate = Candidate.find(params[:id])
    @response = Response.new
    @committee_members = User.where(:user_type => User::COMMITTEE)
  end

  def edit
    @candidate = Candidate.find(params[:id])
  end

  def send_response
    @candidate = Candidate.find(params[:id])
    if @candidate.status == Candidate::WAITING
      @response = Response.new
      @response.candidate_id = @candidate.id
      @response.level_id = params[:response][:level_id]
      @response.user_id = current_user.id
      @response.comments = params[:response][:comments]
      if @response.save
        flash[:success] = "Nivel #{@response.level.full_name} enviado exitosamente"
        redirect_to @candidate
      else
        flash[:error] = "Error al enviar la respuesta"
      end
    else
      flash[:alert] = "La votación ya se ha cerrado"
    end

  end

  def desagree
    @candidate = Candidate.find(params[:id])
    if @candidate.status == Candidate::DISAGREE
      @candidate.decision_type = Candidate::NOT_COMMITTEE
      @candidate.level_id = params[:candidate][:level_id]
      @candidate.comments = params[:candidate][:comments]
      @candidate.status = Candidate::FINALIZED

      if @candidate.save
        flash[:alert] = "Se seleccionó manualmente el nivel a #{@candidate.name}"
        redirect_to @candidate
      else
        render plain: 'Error al dar nivel'
      end
    end
  end

  def candidates_waiting
    @candidates_waiting = Candidate.where(:status => Candidate::WAITING)
  end

  def candidates_finalized
    @candidates_voted = Candidate.where.not(:status => Candidate::WAITING)
  end

  def document

    if is_admin
      candidate = Candidate.find(params[:id])
      pdf = Prawn::Document.new
      pdf.font 'Helvetica'
      pdf.text candidate.name, size: 40
      pdf.font 'Times-Roman'
      pdf.text "holi", size: 84
      send_data pdf.render, filename: "contratacion#{candidate.name}.pdf", type: 'application/pdf', disposition: 'inline'
    else
      flash[:error] = "Sólo el administrador puede realizar esta acción"
      redirect_to root_path
    end

  end

  def close_votation
    if is_admin
      candidate = Candidate.find(params[:id])
      responses = Response.where(candidate: candidate)
      if responses.size > 0
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
        more_vote = levels_hash.max_by {|k, v| v}
        members = User.where(user_type: User::COMMITTEE).size
        if more_vote[1] > members/2
          candidate.level = Level.find(more_vote[0])
          candidate.status = Candidate::FINALIZED
          candidate.decision_type = Candidate::UNANIMITY
          flash[:success] = "#{candidate.name} obtuvo el nivel #{candidate.level.full_name} por unanimidad"

        else
          candidate.status = Candidate::DISAGREE
          flash[:alert] = 'No se pudo tomar decisión unánime'
        end
        if candidate.save!
          flash[:alert] = 'Se cerró la votación manualmente'
        else
          flash[:alert] = 'Error a otorgar nivel'
        end
        redirect_to candidate
      else
        flash[:alert] = "Debe haber al menos 1 voto"
        redirect_to candidate
      end
    else
      flash[:error] = "Sólo el administrador puede realizar esta acción"
      redirect_to root_path
    end
  end


  private

  def candidate_params
    params.require(:candidate).permit(:name, :department_id, :sni, :function, :degree, :curriculum)
  end
end
