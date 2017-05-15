class CandidatesController < ApplicationController
  before_action :auth_required
  skip_before_filter :verify_authenticity_token
  def index
    @candidates_waiting = Candidate.where(:status => Candidate::WAITING)
    @candidates_voted = Candidate.where(:status => Candidate::FINALIZED)

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
      flash[:success] = "Se creó exitosamente al candidato: #{@candidate.name}"
      redirect_to @candidate
    else
      flash[:error] = "Error al crear candidato"
      render :new
    end
  end

  def update
    @candidate = Candidate.find(params[:id])
    if @candidate.update(candidate_params)
      flash[:success] = "Se actualizó al candidato: #{@candidate.name}"
      redirect_to @candidate
    else
      flash[:error] = "Error al actualizar candidato"
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
      @response = Response.new
      @response.candidate_id = @candidate.id
      @response.level_id = params[:response][:level_id]
      @response.user_id = current_user.id
      @response.comments = params[:response][:comments]
      if @response.save
        flash[:success] = "Nivel #{@response.level.full_name} enviado exitosamente"
        redirect_to @candidate
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
        render plain:'Error al dar nivel'
      end
    end
  end

  def candidates_waiting
    @candidates_waiting = Candidate.where(:status => Candidate::WAITING)
  end

  def candidates_finalized
    @candidates_voted = Candidate.where.not(:status => Candidate::WAITING)
  end

  def levels
    level = Level.find(params[:id])
    render plain: level.requirements
  end



  private

  def candidate_params
    params.require(:candidate).permit(:name, :department_id, :sni, :function, :degree, :curriculum)
  end
end
