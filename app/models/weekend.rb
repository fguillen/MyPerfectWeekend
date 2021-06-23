class Weekend < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  belongs_to :front_user

  validates :city, presence: true
  validates :body, length: { in: 20..65_535 }

  scope :order_by_recent, -> { order("created_at desc") }

  before_validation :init_city, on: :create

  def init_city
    self.city ||= "Berlin"
  end
end
