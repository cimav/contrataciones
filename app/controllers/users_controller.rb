class UsersController < ApplicationController
  before_action :auth_required
  def index
    @admin_users = User.where(user_type:User::ADMIN, status: 1)
    @committee_users = User.where(user_type:User::COMMITTEE, status: 1)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id]
)
  end

  def create

    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Se creó exitosamente al usuario: #{@user.name}"
      redirect_to users_path
    else
      flash[:error] = "Error al crear usuario"
      render :new
    end
  end

  def update
    if is_admin
      @user = User.find(params[:id])
      if @user.update(user_params)
        flash[:notice] = "Se actualizó al usuario: #{@user.name}"
        redirect_to users_path
      else
        flash[:error] = "Error al actualizar usuario"
        render :edit
      end
    else
      flash[:error] = "Sólo el administrador puede realizar esta acción"
      redirect_to root_path
    end
  end

  def destroy
    if is_admin
      user = User.find(params[:id])
      #Elimina el objeto de la BD
      if user.destroy
        flash[:notice] = "Se eliminó a #{user.name}"
        redirect_to candidates_path
      else
        flash[:error] = "Error al eliminar candidato"
      end
    else
      flash[:error] = "Sólo el administrador puede realizar esta acción"
      redirect_to root_path
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :department_id, :email, :user_type)
  end
end
