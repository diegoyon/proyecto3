class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[ edit update destroy ]
  load_and_authorize_resource

  def index
    @activities = current_user.activities.order(created_at: :desc).page(params[:page])
    return unless params[:query].present?
    @activities = @activities.where('lower(description) LIKE :query', query: "%#{params[:query].downcase}%")
  end

  def new
    @activity = Activity.new
  end

  def edit
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      flash[:notice] = "Activity was successfully created."
      redirect_to activities_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @activity.update(activity_params)
      flash[:notice] = "Activity was successfully updated."
      redirect_to activities_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity.destroy
    flash[:notice] = "Activity was successfully deleted."
    redirect_to activities_url
  end

  private
    def set_activity
      @activity = Activity.find(params[:id])
    end

    def activity_params
      params.require(:activity).permit(:calories, :burned, :description, :date).with_defaults(user_id: current_user.id)
    end
end
