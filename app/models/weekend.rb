class Weekend < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  STATUS = [
    "draft",
    "moderation_pending",
    "published"
  ].freeze

  belongs_to :front_user, optional: true

  validates :city, presence: true
  validates :body, length: { in: 20..65_535 }
  validates :status, inclusion: { in: STATUS }, length: { maximum: 32 }

  scope :order_by_recent, -> { order("created_at desc") }
  scope :published, -> { where(status: "published") }

  before_validation :init_city, on: :create
  before_validation :init_status, on: :create

  def init_city
    self.city ||= "Berlin"
  end

  def init_status
    self.status ||= "draft"
  end

  def published?
    status == "published"
  end
end
