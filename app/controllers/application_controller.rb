class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticated?
    if session[:user_auth].blank?
      logger.info "############### |#{session[:user_email]}|"
      user = User.where(:email => session[:user_email]).first
      logger.info "############### |#{user.email rescue "NULL"}|"

      session[:user_auth] = user && user.email == session[:user_email]
      if session[:user_auth]
        session[:user_id] = user.id
      end
    else
      session[:user_auth]
    end
  end

  helper_method :authenticated?

  def auth_required
    redirect_to '/login' unless authenticated?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def is_admin
    current_user.user_type == User::ADMIN || current_user.user_type == User::SUPER_USER
  end

  helper_method :current_user
  helper_method :is_admin

  def get_candidates_waiting
    @candidates_waiting_number = Candidate.where(:status => Candidate::WAITING).size
  end

  def get_month_name(number)
    months = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]
    name = months[number - 1]
    return name
  end
  helper_method :get_candidates_waiting
end
