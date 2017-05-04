class HomeController < ApplicationController
  before_action :auth_required
  def index
    if is_admin
      render :template => 'home/admin-index'
    else
      render :template => 'home/members-index'
    end
  end
end
