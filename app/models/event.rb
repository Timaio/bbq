class Event < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  has_many :photos, dependent: :delete_all

  validates :user, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :address, presence: true
  validates :datetime, presence: true

  def pincode_correct?(pincode_to_check)
    pincode == pincode_to_check
  end
end
