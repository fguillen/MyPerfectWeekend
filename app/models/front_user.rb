class FrontUser < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid
  strip_attributes

  acts_as_authentic do |config|
    config.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
    config.session_class = FrontSession
  end

  has_many :authorizations, class_name: "FrontAuthorization", dependent: :destroy

  has_many :posts, dependent: :destroy
  # validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: RubyRegex::Email }, allow_blank: true
  # validates :password, presence: true, on: :create
  # validates :password, confirmation: true, allow_blank: true
  validates :country, length: { maximum: 30 }, allow_blank: true
  validates :wannabe, length: { maximum: 100 }, allow_blank: true
  validates :age, numericality: { only_integer: true }, allow_blank: true

  validates_with PasswordValidator, unless: -> { password.blank? }

  scope :order_by_recent, -> { order("created_at desc") }

  def name_or_anonymous
    name || "Anonymous"
  end

  def send_reset_password_email
    reset_perishable_token!
    Notifier.front_user_reset_password(self).deliver
  end
end
