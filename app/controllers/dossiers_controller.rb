class DossiersController < ApplicationController


  # set a non-default layout for dossier viewing
  # layout :resolve_layout


  def new
    # @user = User.new
    # @user= User.find(params[:user_id])
  end

  def create
    # @user = User.find(params[:user_id])
    # raise params.inspect
    @user = User.new(params[:user])
    @user.password = "abc"
    @user.dossiers.build(params[:dossier])
    @user.save_with_dossier_status("submitted")
    session[:user_id] = @user.id
    redirect_to @user.dossiers.first
  end 

  def index
    @dossiers = Dossier.sort_by(params[:sort_by])
    @title = "Admin Zone"
  end
  
  # def filter
  #   raise params.inspect
  # end

  def filter_by
    if DossierStatus.list.include? params[:filter]
      @dossiers = Dossier.filter_by(params[:filter])
    elsif params[:filter] == "all"
      @dossiers = Dossier.find(:all)
    else
      @dossiers = []
    end
  end

  def show
    @dossier = Dossier.find(params[:id])
    @user = @dossier.user
  end

  def transition
    @dossier = Dossier.find(params[:id])
    @dossier.send(params[:transition])
    redirect_to dashboard_path, :anchor => "dossier-#{params[:id]}"
  end


  private

  # def resolve_layout
  #   case action_name
  #   when "new", "create"
  #     "applicant"
  #   else
  #     "application"
  #   end
  # end

    
end
