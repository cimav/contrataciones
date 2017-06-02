class DepartmentsController < ApplicationController
  def create
    department = Department.new()
    department.name = params[:name]
    if department.save
      flash[:notice] = "Departamento #{department.name} agregado"
    else
      flash[:error] = "Error al crear departamento"
    end
  end
end
