class Api::V1::ReservationSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :status, :currency,
    :payout_price, :security_price, :total_price, :total_nights,
    :total_guests, :number_of_adults, :number_of_children, :number_of_infants
end
