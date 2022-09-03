class User < ApplicationRecord
  devise :database_authenticatable, 
         :registerable,
         :recoverable, 
         :rememberable, 
         :validatable
  
  has_many :events, dependent: :destroy
  has_many :comments
  has_many :subscriptions

  before_validation :set_user, on: :create

  validates :name, presence: true

  after_commit :link_subscriptions, on: :create

  private

  def set_user
    self.name = "User #{rand(1000)}" if self.name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email).update_all(user_id: self.id)
  end
end
