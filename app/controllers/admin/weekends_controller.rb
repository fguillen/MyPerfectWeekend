class Admin::WeekendsController < Admin::BaseController
  before_action :require_admin_user
  before_action :load_weekend, only: [:show, :edit, :update, :destroy]

  def index
    @weekends = Weekend.order_by_recent
  end

  def show; end

  def new
    @weekend = Weekend.new
  end

  def create
    @weekend = Weekend.new(weekend_params)

    if @weekend.save
      redirect_to [:admin, @weekend], notice: t("controllers.weekends.create.success")
    else
      flash.now[:alert] = t("controllers.weekends.create.error")
      render action: :new
    end
  end

  def edit; end

  def update
    Rails.logger.debug "params: #{weekend_params.inspect}"
    if @weekend.update(weekend_params)
      redirect_to [:admin, @weekend], notice: t("controllers.weekends.update.success")
    else
      flash.now[:alert] = t("controllers.weekends.update.error")
      render action: :edit
    end
  end

  def destroy
    @weekend.destroy
    redirect_to :admin_weekends, notice: t("controllers.weekends.destroy.success")
  end

  protected

  def weekend_params
    params.require(:weekend).permit(:front_user_id, :title, :body, :status)
  end

  private

  def load_weekend
    @weekend = Weekend.find(params[:id])
  end
end
