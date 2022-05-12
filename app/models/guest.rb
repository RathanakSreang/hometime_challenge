class Guest < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :reservations, dependent: :destroy

  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
    format: VALID_EMAIL_REGEX,
    uniqueness: true,
    length: { minimum: 4, maximum: 254 }

  before_save :downcase_email

  class << self
    def find_by_email_or_initialize(attributes)
      find_by(email: attributes[:email]) || new(attributes)
    end
  end

  private
    def downcase_email
      self.email.downcase! if self.email
    end
end
