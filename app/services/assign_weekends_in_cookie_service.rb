# TODO: test this
class AssignWeekendsInCookieService < Service
  def perform(front_user, cookies)
    return if cookies[:orphan_weekends].blank?

    JSON.parse(cookies[:orphan_weekends]).each do |weekend_uuid|
      weekend = Weekend.find(weekend_uuid)
      weekend.update!(front_user: front_user)
    end

    cookies.delete :orphan_weekends
  end
end
