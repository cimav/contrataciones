class SessionsController < ApplicationController
  def create
    session[:user_email] = auth_hash['info']['email']

    if authenticated?
      redirect_to '/'
    else
      render :html => '<h1>Acceso no autorizado</h1>'.html_safe, :status => 401
    end
  end

  def destroy
    reset_session
    redirect_to '/login'
  end

  def failure
    render :plain => '403 Auth method has failed', :status => 403
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end
end