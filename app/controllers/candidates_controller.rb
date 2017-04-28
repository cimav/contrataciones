class CandidatesController < ApplicationController
  before_action :auth_required
  def index
    @candidates_waiting = Candidate.where(:status => Candidate::WAITING)
    @candidates_finalized = Candidate.where(:status => Candidate::FINALIZED)
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
      redirect_to @candidate
    else
      render :new
    end
  end

  def show
    @candidate = Candidate.find(params[:id])
    @response = Response.new
    @committee_members = User.where(:user_type => User::COMMITTEE)
  end

  def edit
  end

  def send_response
    if current_user.user_type ==User::COMMITTEE
      @candidate = Candidate.find(params[:id])
      @response = Response.new
      @response.candidate_id = @candidate.id
      @response.level_id = params[:response][:level_id]
      @response.user_id = current_user.id
      @response.comments = 'adfv,snfdvksdjn'
      if @response.save
        redirect_to @candidate
      else
        render plain: 'no se armó'
      end
    else
      render plain: 'Solo los mienbros del comité pueden elegir el nivel'
    end
  end

  private

  def candidate_params
    params.require(:candidate).permit(:name, :department_id, :email, :function, :degree)
  end
end
