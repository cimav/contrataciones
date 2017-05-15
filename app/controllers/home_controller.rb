class HomeController < ApplicationController
  before_action :auth_required
  def index
    if is_admin
      render :template => 'home/admin-index'
    else
      render :template => 'candidates/index'
    end
  end
end
