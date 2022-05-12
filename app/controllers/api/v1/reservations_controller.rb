module Api
  module V1
    class ReservationsController < Api::V1::ApiController
      before_action :load_reservation, only: [:show]

      def index
        reservations = Reservation.all
        render json: {
          reservations: ActiveModel::Serializer::CollectionSerializer.new(
            reservations, serializer: Api::V1::ReservationSerializer
          )
        }
      end

      def show
        render json: { reservation: Api::V1::ReservationDetailSerializer.new(@reservation) }
      end

      def registration
        reservation, errors = reservation_service.create(params)
        if errors.empty?
          render json: { reservation: }
        else
          respond_with_error("invalid_resource", errors)
        end
      end

      private
        def reservation_service
          @reservation_service ||= ReservationService.new
        end

        def load_reservation
          @reservation ||= Reservation.find params[:id]
        end
    end
  end
end
