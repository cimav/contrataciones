class CandidatesController < ApplicationController
  before_action :auth_required
  def index
    @candidates = Candidate.all
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
  end

  def edit
  end

  private

  def candidate_params
    params.require(:candidate).permit(:name, :department_id, :email, :function, :degree)
  end
end
