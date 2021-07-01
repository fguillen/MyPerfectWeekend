class Front::WeekendsController < Front::BaseController
  before_action :load_weekend, only: [:show, :edit, :update, :destroy]
  before_action :require_front_user, only: [:my_weekends, :edit, :update, :destroy]
  before_action :validate_current_front_user, only: [:edit, :update, :destroy]

  def index
    @weekends = Weekend.published.order_by_recent
  end

  def my_weekends
    @weekends = Weekend.where(front_user: current_front_user).order_by_recent

    if @weekends.empty?
      redirect_to :new_front_weekend, notice: t("controllers.weekends.my_weekends.no_weekends")
    end
  end

  def show; end

  def random
    @weekend = Weekend.published.sample # TODO: optimize this
    redirect_to [:front, @weekend]
  end

  def new
    @weekend = Weekend.new(front_user: current_front_user, body: "My perfect weekend starts on Friday at 18:00")
  end

  def create
    @weekend = Weekend.new(weekend_params)
    @weekend.front_user = current_front_user
    @weekend.status = "moderation_pending"

    if @weekend.save
      if current_front_user.nil?
        StoreWeekendInCookieService.perform(@weekend, cookies)
        redirect_to :new_front_front_user, notice: t("controllers.weekends.create.success_new_front_user")
      else
        redirect_to :my_weekends_front_weekends, notice: t("controllers.weekends.create.success")
      end
    else
      flash.now[:alert] = t("controllers.weekends.create.error")
      render action: :new
    end
  end

  def edit; end

  def update
    @weekend.status = "moderation_pending"

    if @weekend.update(weekend_params)
      redirect_to [:front, @weekend], notice: t("controllers.weekends.update.success")
    else
      flash.now[:alert] = t("controllers.weekends.update.error")
      render action: :edit
    end
  end

  def destroy
    @weekend.destroy
    redirect_to :my_weekends_front_weekends, notice: t("controllers.weekends.destroy.success")
  end

  protected

  def weekend_params
    params.require(:weekend).permit(:front_user_id, :city, :body)
  end

  private

  def load_weekend
    @weekend = Weekend.find(params[:id])

    if !@weekend.published? && @weekend.front_user != current_front_user
      raise ActiveRecord::RecordNotFound
    end
  end

  def validate_current_front_user
    if @weekend.front_user != current_front_user
      redirect_to [:front, @weekend], alert: t("controllers.front.access_not_authorized")
      false
    end
  end
end
