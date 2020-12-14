class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])
      if params[:search]
        @find_pets = Pet.find_by_name(params[:search])
      end
  end

  def new
  end

  def create
    application = Application.new(app_params)
    if application.save
      redirect_to application_path(application.id)
    else 
      flash[:notice] = "Please Complete All Fields"
      render :new 
    end 
  end

  # def update
  #   application = Application.find(params[:id])
  #   if params[:pet]
  #     pet = Pet.find(params[:pet])
  #     application.pets << pet
  #   elsif params[:description].empty?
  #     flash[:notice] = "You must enter a description."
  #   else
  #     application[:description] = params[:description]
  #     application[:status] = "Pending"
  #     application.update(app_params)
  #   end
  #   redirect_to "/applications/#{application.id}"
  # end

  private

  def app_params
    params.permit(:status, :name, :street, :city, :state, :zip, :description)
  end
end