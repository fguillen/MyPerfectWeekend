require "test_helper"

class WeekendTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:weekend).valid?
  end

  def test_validations
    weekend = FactoryBot.build(:weekend)
    assert(weekend.valid?)

    weekend = FactoryBot.build(:weekend, body: nil)
    refute(weekend.valid?)

    weekend = FactoryBot.build(:weekend, body: "")
    refute(weekend.valid?)

    weekend = FactoryBot.build(:weekend, body: "A" * 6)
    refute(weekend.valid?)

    weekend = FactoryBot.build(:weekend, body: "A" * 65_536)
    refute(weekend.valid?)

    weekend = FactoryBot.build(:weekend, body: "A" * 30)
    assert(weekend.valid?)

    weekend = FactoryBot.build(:weekend, front_user: nil)
    assert(weekend.valid?)
  end

  def test_uuid_on_create
    weekend = FactoryBot.build(:weekend)
    assert_nil(weekend.uuid)

    weekend.save!

    assert_not_nil(weekend.uuid)
  end

  def test_primary_key
    weekend = FactoryBot.create(:weekend)

    assert_equal(weekend, Weekend.find(weekend.uuid))
  end

  def test_relations
    front_user = FactoryBot.create(:front_user)

    weekend = FactoryBot.create(:weekend, front_user: front_user)

    assert_equal(front_user, weekend.front_user)
  end
end
