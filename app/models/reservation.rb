class Reservation < ApplicationRecord
  enum status: %i[pending accepted declined]

  belongs_to :guest

  validates :start_date, :end_date, presence: true
  validates_comparison_of :start_date,
    less_than_or_equal_to: :end_date
  validates_comparison_of :end_date,
    greater_than_or_equal_to: :start_date
  validates_comparison_of :start_date,
    greater_than_or_equal_to: Date.today
  validates_comparison_of :end_date,
    greater_than_or_equal_to: Date.today
  validates :status, inclusion: { in: statuses.keys }
  validates :total_nights, :total_guests, :number_of_adults,
    :number_of_children, :number_of_infants, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }
  validates :payout_price, :security_price, :total_price, presence: true, numericality: {
    greater_than_or_equal_to: 0
  }
end
