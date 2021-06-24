class Front::WeekendsController < Front::BaseController
  before_action :load_weekend, only: [:show, :edit, :update, :destroy]
  before_action :require_front_user, only: [:edit, :update, :destroy]
  before_action :validate_current_front_user, only: [:edit, :update, :destroy]

  def index
    @weekends = Weekend.order_by_recent
  end

  def show; end

  def new
    @weekend = Weekend.new(front_user: current_front_user)
  end

  def create
    @weekend = Weekend.new(weekend_params)
    @weekend.front_user = current_front_user

    if @weekend.save
      redirect_to [:front, @weekend], notice: t("controllers.weekends.create.success")
    else
      flash.now[:alert] = t("controllers.weekends.create.error")
      render action: :new
    end
  end

  def edit; end

  def update
    if @weekend.update(weekend_params)
      redirect_to [:front, @weekend], notice: t("controllers.weekends.update.success")
    else
      flash.now[:alert] = t("controllers.weekends.update.error")
      render action: :edit
    end
  end

  def destroy
    @weekend.destroy
    redirect_to :front_weekends, notice: t("controllers.weekends.destroy.success")
  end

  protected

  def weekend_params
    params.require(:weekend).permit(:front_user_id, :city, :body)
  end

  private

  def load_weekend
    @weekend = Weekend.find(params[:id])
  end

  def validate_current_front_user
    if @weekend.front_user != current_front_user
      redirect_to [:front, @weekend], alert: t("controllers.front.access_not_authorized")
      false
    end
  end
end
