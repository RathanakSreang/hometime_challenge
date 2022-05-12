class Api::V1::ReservationDetailSerializer < Api::V1::ReservationSerializer
  belongs_to :guest, serializer: Api::V1::GuestSerializer
end
