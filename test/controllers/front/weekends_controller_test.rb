require "test_helper"

class Front::WeekendsControllerTest < ActionController::TestCase
  def setup
    setup_front_user
  end

  def test_index
    weekend_1 = FactoryBot.create(:weekend, created_at: "2020-04-25")
    weekend_2 = FactoryBot.create(:weekend, created_at: "2020-04-26")

    get :index

    assert_template "front/weekends/index"
    assert_primary_keys([weekend_2, weekend_1], assigns(:weekends))
  end

  def test_my_weekends
    front_user_other = FactoryBot.create(:front_user)
    weekend_1 = FactoryBot.create(:weekend, front_user: @front_user, created_at: "2020-04-25")
    weekend_2 = FactoryBot.create(:weekend, front_user: @front_user, created_at: "2020-04-26")
    _weekend_3 = FactoryBot.create(:weekend, front_user: front_user_other, created_at: "2020-04-27")

    get :my_weekends

    assert_template "front/weekends/my_weekends"
    assert_primary_keys([weekend_2, weekend_1], assigns(:weekends))
  end

  def test_show
    weekend = FactoryBot.create(:weekend)

    get :show, params: { id: weekend }

    assert_template "front/weekends/show"
    assert_equal(weekend, assigns(:weekend))
  end

  def test_show_raise_404_if_weekend_not_published_and_not_same_front_user
    front_user = FactoryBot.create(:front_user)
    weekend = FactoryBot.create(:weekend, status: "moderation_pending", front_user: front_user)

    assert_raise(ActiveRecord::RecordNotFound) do
      get :show, params: { id: weekend }
    end
  end

  def test_show_if_weekend_not_published_and_same_front_user
    weekend = FactoryBot.create(:weekend, status: "moderation_pending", front_user: @front_user)

    get :show, params: { id: weekend }

    assert_template "front/weekends/show"
    assert_equal(weekend, assigns(:weekend))
  end

  def test_new
    get :new
    assert_template "front/weekends/new"
    assert_not_nil(assigns(:weekend))
  end

  def test_create_invalid
    front_user_1 = FactoryBot.create(:front_user)

    Weekend.any_instance.stubs(:valid?).returns(false)

    post(
      :create,
      params: {
        weekend: {
          front_user_id: front_user_1,
          city: "The Title Wadus"
        }
      }
    )

    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    post(
      :create,
      params: {
        weekend: {
          city: "The Title Wadus",
          body: "The Body Wadus Wadus Wadus Wadus",
        }
      }
    )

    weekend = Weekend.last
    assert_redirected_to :my_weekends_front_weekends

    assert_equal("The Title Wadus", weekend.city)
    assert_equal("The Body Wadus Wadus Wadus Wadus", weekend.body)
    assert_equal(@front_user, weekend.front_user)
  end

  def test_edit
    weekend = FactoryBot.create(:weekend, front_user: @front_user)

    get :edit, params: { id: weekend }

    assert_template "edit"
    assert_equal(weekend, assigns(:weekend))
  end

  def test_update_invalid
    weekend = FactoryBot.create(:weekend, front_user: @front_user)

    Weekend.any_instance.stubs(:valid?).returns(false)

    put(
      :update,
      params: {
        id: weekend,
        weekend: {
          city: "The New Title"
        }
      }
    )

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    weekend = FactoryBot.create(:weekend, front_user: @front_user)

    put(
      :update,
      params: {
        id: weekend,
        weekend: {
          city: "The New Title"
        }
      }
    )

    assert_redirected_to [:front, weekend]
    assert_not_nil(flash[:notice])

    weekend.reload
    assert_equal("The New Title", weekend.city)
  end

  def test_destroy
    weekend = FactoryBot.create(:weekend, front_user: @front_user)

    delete :destroy, params: { id: weekend }

    assert_redirected_to :my_weekends_front_weekends
    assert_not_nil(flash[:notice])

    assert !Weekend.exists?(weekend.id)
  end

  def test_edit_not_allowed
    front_user = FactoryBot.create(:front_user)
    weekend = FactoryBot.create(:weekend, front_user: front_user)

    get(
      :edit,
      params: {
        id: weekend
      }
    )

    assert_redirected_to [:front, weekend]
    assert_not_nil(flash[:alert])
  end

  def test_update_not_allowed
    front_user = FactoryBot.create(:front_user)
    weekend = FactoryBot.create(:weekend, front_user: front_user)

    put(
      :update,
      params: {
        id: weekend,
        weekend: {
          message: "The Wadus Message New"
        }
      }
    )

    assert_redirected_to [:front, weekend]
    assert_not_nil(flash[:alert])
  end

  def test_destroy_not_allowed
    front_user = FactoryBot.create(:front_user)
    weekend = FactoryBot.create(:weekend, front_user: front_user)

    delete(
      :destroy,
      params: {
        id: weekend
      }
    )

    assert_redirected_to [:front, weekend]
    assert_not_nil(flash[:alert])
  end
end
