class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]
  def index
    @prototypes = Prototype.all
  end

  def new
    @prototypes = Prototype.new
  end

  def create
    @prototypes = Prototype.create(prototype_params)
    if @prototypes.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @prototype = Prototype.find(params[:id])
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototypes = Prototype.find(params[:id])
    unless current_user.id == @prototypes.user.id
      redirect_to action: :index
    end
  end
  
  def update
    @prototypes = Prototype.find(params[:id])
    if @prototypes.update(prototype_params)
      redirect_to prototype_path(@prototypes.id)
    else
      render :edit
    end
  end

  def destroy
    @prototypes = Prototype.find(params[:id])
    @prototypes.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

end
