class User < ApplicationRecord
  has_secure_password
  has_secure_token :access_token

  has_many :orders, dependent: :restrict_with_exception

  belongs_to :inventory

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 255 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password,
            presence: { on: :create },
            length: { minimum: 6, maximum: 32 },
            allow_nil: true
  validates :access_token,
            presence: true,
            uniqueness: true

  before_save { email.downcase! }
end
