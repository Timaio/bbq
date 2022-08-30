class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :events

  before_validation :set_user, on: :create

  validates :name, presence: true

  def set_user
    self.name = "User #{rand(1000)}" if self.name.blank?
  end
end
