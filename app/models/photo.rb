class Photo < ApplicationRecord
  belongs_to :event
  belongs_to :user

  has_one_attached :photo

  validates :event, presence: true
  validates :user, presence: true
  validates :photo, presence: true

  scope :persisted, -> { where "id IS NOT NULL"}
end
