FactoryBot.define do
  factory :reservation do
    guest factory: :guest
    start_date { Date.current + 1.day }
    end_date { Date.current + 2.day }
    status { :accepted }
    total_nights { 1 }
    total_guests { 2 }
    number_of_adults { 2 }
    number_of_children { 0 }
    number_of_infants { 0 }
    payout_price { 100 }
    security_price { 10 }
    total_price { 110 }
  end
end
