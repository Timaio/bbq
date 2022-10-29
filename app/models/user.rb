class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :events, dependent: :destroy
  has_many :comments
  has_many :subscriptions
  has_many :photos

  has_one_attached :avatar

  before_validation :set_user, on: :create

  validates :name, presence: true

  after_commit :link_subscriptions, on: :create

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  def set_user
    self.name = I18n.t("activerecord.attributes.user.name_empty_state") if self.name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email).update_all(user_id: self.id)
  end
end
