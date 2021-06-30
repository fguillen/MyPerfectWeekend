require "test_helper"

class Admin::WeekendsControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    weekend_1 = FactoryBot.create(:weekend, created_at: "2020-04-25")
    weekend_2 = FactoryBot.create(:weekend, created_at: "2020-04-26")

    get :index

    assert_template "admin/weekends/index"
    assert_primary_keys([weekend_2, weekend_1], assigns(:weekends))
  end

  def test_show
    weekend = FactoryBot.create(:weekend)

    get :show, params: { id: weekend }

    assert_template "admin/weekends/show"
    assert_equal(weekend, assigns(:weekend))
  end

  def test_new
    get :new
    assert_template "admin/weekends/new"
    assert_not_nil(assigns(:weekend))
  end

  def test_create_invalid
    front_user_1 = FactoryBot.create(:front_user)

    Weekend.any_instance.stubs(:valid?).returns(false)

    post(
      :create,
      params: {
        weekend: {
          front_user: front_user_1,
          body: "The Body Wadus"
        }
      }
    )

    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    front_user_1 = FactoryBot.create(:front_user)

    post(
      :create,
      params: {
        weekend: {
          front_user_id: front_user_1,
          body: "Wadus Message longer than 20 chars"
        }
      }
    )

    weekend = Weekend.last
    assert_redirected_to [:admin, weekend]

    assert_equal("Wadus Message longer than 20 chars", weekend.body)
    assert_equal(front_user_1, weekend.front_user)
  end

  def test_edit
    weekend = FactoryBot.create(:weekend)

    get :edit, params: { id: weekend }

    assert_template "edit"
    assert_equal(weekend, assigns(:weekend))
  end

  def test_update_invalid
    weekend = FactoryBot.create(:weekend)

    Weekend.any_instance.stubs(:valid?).returns(false)

    put(
      :update,
      params: {
        id: weekend,
        weekend: {
          body: "Wadus Message longer than 20 chars"
        }
      }
    )

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    weekend = FactoryBot.create(:weekend)

    put(
      :update,
      params: {
        id: weekend,
        weekend: {
          body: "Wadus Message longer than 20 chars"
        }
      }
    )

    assert_redirected_to [:admin, weekend]
    assert_not_nil(flash[:notice])

    weekend.reload
    assert_equal("Wadus Message longer than 20 chars", weekend.body)
  end

  def test_destroy
    weekend = FactoryBot.create(:weekend)

    delete :destroy, params: { id: weekend }

    assert_redirected_to :admin_weekends
    assert_not_nil(flash[:notice])

    assert !Weekend.exists?(weekend.id)
  end
end
