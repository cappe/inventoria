class User < ApplicationRecord
  has_secure_password
  has_secure_token :access_token

  has_many :orders, dependent: :restrict_with_error

  # This association is optional when user is admin
  belongs_to :inventory, optional: true

  USER_ROLES = %w(customer admin)

  enum role: USER_ROLES

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
            uniqueness: true
  validates :role,
            presence: true,
            inclusion: { in: USER_ROLES }

  before_save { email.downcase! }
  before_validation :set_default_password

  def type
    self.user_type
  end

  def is_customer
    self.customer?
  end

  def is_admin
    self.admin?
  end

  private

    def set_default_password
      return if self.password

      self.password = self.password_confirmation = 'foobar'
    end
end
