class StoreWeekendInCookieService < Service
  def perform(weekend, cookies)
    actual_weekend_uuids = cookies[:orphan_weekends].blank? ? [] : JSON.parse(cookies[:orphan_weekends])
    actual_weekend_uuids.push(weekend.uuid)

    cookies[:orphan_weekends] = { value: JSON.generate(actual_weekend_uuids), expires: 1.month.from_now }
  end
end
