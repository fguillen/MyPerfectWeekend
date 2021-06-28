require "test_helper"

class WeekendsInCookieBeforeLoginTest < ActionDispatch::IntegrationTest
  def test_storing_and_recovering_weekend_from_cookie_when_front_user_created
    # Creating the Weekend
    assert_difference("Weekend.count", 1) do
      post(
        "/front/weekends",
        params: {
          weekend: {
            body: "This is the body of the weekend"
          }
        }
      )
    end

    assert_redirected_to :new_front_front_user

    weekend = Weekend.last
    assert_nil(weekend.front_user)

    # Creating the FrontUser
    assert_difference("FrontUser.count", 1) do
      post(
        "/front/front_users",
        params: {
          front_user: {
            name: "Fermin"
          }
        }
      )
    end

    assert_redirected_to :my_weekends_front_weekends

    front_user = FrontUser.last
    weekend.reload

    assert_equal(front_user, weekend.front_user)
  end
end
