class HomeController < ApplicationController
  before_action :auth_required
  def index
    if is_admin
      render :template => 'home/admin-index'
    else
      render :template => 'candidates/index'
    end
  end

  def nivel

  end
  def set_nivel
    nivel = Level.find(:id)
    nivel.requirements = params[:requirements]
    nivel.save
  end
end
