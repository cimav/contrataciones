class CandidatesController < ApplicationController
  before_action :auth_required
  skip_before_action :verify_authenticity_token


  def index
    @candidates_waiting = Candidate.where(:status => Candidate::WAITING).order("created_at DESC")
    @candidates_voted = Candidate.where.not(:status => Candidate::WAITING).order("created_at DESC")

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
    if is_admin
      data = candidate_params
      data[:status] = Candidate::WAITING
      data[:level_id] = Level::WITHOUT_LEVEL
      @candidate = Candidate.new(data)
      if @candidate.save(data)
        ContratacionesMailer.new_candidate(@candidate).deliver_now
        flash[:success] = "Se creó exitosamente al candidato: #{@candidate.name}"
        redirect_to @candidate
      else
        flash[:error] = "Error al crear candidato"
        flash[:alert] = @candidate.errors.full_messages[0]
        render :new
      end
    else
      flash[:error] = "Sólo el administrador puede realizar esta acción"
      redirect_to root_path
    end

  end

  def update
    if is_admin
      @candidate = Candidate.find(params[:id])
      if @candidate.update(candidate_params)
        flash[:notice] = "Se actualizó al candidato: #{@candidate.name}"
        redirect_to @candidate
      else
        flash[:error] = "Error al actualizar candidato"
        flash[:alert] = @candidate.errors.full_messages[0]
        render :edit
      end
    else
      flash[:error] = "Sólo el administrador puede realizar esta acción"
      redirect_to root_path
    end
  end

  def show
    @candidate = Candidate.find(params[:id])
    @response = Response.new
    @committee_members = User.where(:user_type => User::COMMITTEE)
  end

  def destroy
    if is_admin
      candidate = Candidate.find(params[:id])
      #Elimina el objeto de la BD
      if candidate.destroy
        flash[:notice] = "Se eliminó a #{candidate.name}"
        redirect_to candidates_path
      else
        flash[:error] = "Error al eliminar candidato"
      end
    else
      flash[:error] = "Sólo el administrador puede realizar esta acción"
      redirect_to root_path
    end
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
    @candidates_waiting = Candidate.where(:status => Candidate::WAITING).order("created_at DESC")
  end

  def candidates_finalized
    @candidates_voted = Candidate.where.not(:status => Candidate::WAITING).order("created_at DESC")
  end

  def document

    if is_admin
      candidate = Candidate.find(params[:id])
      pdf = Prawn::Document.new(background: "private/membretada.png", background_scale: 0.36, right_margin: 20)
      pdf.font 'Helvetica'
      y= 600
      text = "Chihuahua, Chih., a #{Date.today.day} de #{get_month_name(Date.today.month)} del #{Date.today.year}" +
      "\n Dirección Académica"
      pdf.text_box text, size: 11, at:[320,y]
      text = "Lic. María Eugenia Rangel Márquz,\n Jefa del Departamento de Recursos Humanos"
      pdf.text_box text, size: 11, at:[20,y-=50]
      pdf.formatted_text_box([:text => "Presente.-", :size => 12, :styles => [:bold] ], at:[20,y-=50])
      text = "En relación a la contratación del personal académico, me permito comunicarle que con base al Estatuto del "+
        "Personal Académico del CIMAV y del currículum del interesado, el Consejo Académico Interno tomó la decisión de "+
        "contratar a #{candidate.name} con el nivel y categoría #{candidate.level.full_name}."
      pdf.text_box text, size: 11, at:[20,y-=50]
      text = "#{candidate.name} se integrará #{(candidate.department.name.include? "Departamento") ? "al":"a" } #{candidate.department.name}, "+
        "realizando las siguientes funciones:"
      pdf.text_box text, size: 11, at:[20,y-=70]
      text = "#{candidate.function}"
      pdf.text_box text, size: 11, at:[20,y-=50]
      text = "A T E N T A M E N T E"
      pdf.text_box text, size: 11, at:[0,150], align: :center
      text = "Dr. José Alberto Duarte Möller \n Director Académico"
      pdf.text_box text, size: 11, at:[0,80], align: :center

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

  def display_curriculum
    cv = Candidate.find(params[:id]).curriculum
    send_file cv.to_s, disposition:'inline'
  end


  private

  def candidate_params
    params.require(:candidate).permit(:name, :department_id, :title, :sni, :function, :degree, :curriculum)
  end
end
