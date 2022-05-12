class ReservationService < BaseService
  def create(params)
    attributes = parse_attributes(params)

    unless attributes[:guest] && attributes[:reservation]
      return [nil, [{ payload: "invalid" }]]
    end

    errors = []
    reservation = nil
    ActiveRecord::Base.transaction do
      guest = Guest.find_by_email_or_initialize(attributes[:guest])
      unless guest.save
        errors << { guest: guest.errors.to_hash }
        raise ActiveRecord::Rollback
      end

      reservation = guest.reservations.new attributes[:reservation]
      unless reservation.save
        errors << { reservation: reservation.errors.to_hash }
        raise ActiveRecord::Rollback
      end
    end

    [reservation, errors]
  end

  def parse_attributes(params)
    attributes = {}
    RESERVATION_PAYLOADS_MAPPER.each do |_, payload|
      if array_contain_all?(params.keys, payload["identifier_keys"])
        attributes[:guest] = mapping_attributes(params, payload["guest_fields_mapper"])
        attributes[:reservation] = mapping_attributes(params, payload["reservation_fields_mapper"])
        break
      end
    end

    attributes
  end
end
