require "rails_helper"

RSpec.describe "ReservationService" do
  let(:reservation_service) { ReservationService.new }
  let(:playload_1_params) { {
    "start_date": Date.current + 1.day,
    "end_date": Date.current + 2.day,
    "nights": 4,
    "guests": 4,
    "adults": 2,
    "children": 2,
    "infants": 0,
    "status": "accepted",
    "guest": {
      "id": 1,
      "first_name": "Wayne",
      "last_name": "Woodbridge",
      "phone": "639123456789",
      "email": "wayne_woodbridge@bnb.com"
    },
    "currency": "AUD",
    "payout_price": "3800.00",
    "security_price": "500",
    "total_price": "4500.00"
  }.with_indifferent_access}
  let(:playload_2_params) { {
    "reservation": {
      "start_date": Date.current + 1.day,
      "end_date": Date.current + 2.day,
      "expected_payout_amount": "3800.00",
      "guest_details": {
        "localized_description": "4 guests",
        "number_of_adults": 2,
        "number_of_children": 2,
        "number_of_infants": 0
      },
      "guest_email": "wayne_woodbridge@bnb.com",
      "guest_first_name": "Wayne",
      "guest_id": 1,
      "guest_last_name": "Woodbridge",
      "guest_phone_numbers": [
          "639123456789",
          "639123456789"
      ],
      "listing_security_price_accurate": "500.00",
      "host_currency": "AUD",
      "nights": 4,
      "number_of_guests": 4,
      "status_type": "accepted",
      "total_paid_amount_accurate": "4500.00"
    }
  }.with_indifferent_access}

  describe ".create" do
    context "payload params not match" do
      let(:params) { {} }

      it "should return nil and payload error" do
        expect(reservation_service.create(params)).to eq([nil, [{ payload: "invalid" }]])
      end
    end

    context "payload params match" do
      context "valid values" do
        it "should return reservation model" do
          reservation, error = reservation_service.create(playload_1_params)
          expect(error).to eq []
          expect(reservation.id).not_to eq nil
        end

        context "guest email does not exist" do
          it "should create guest and reservation" do
            expect {
              reservation_service.create(playload_1_params)
            }.to change { Guest.count }.by(1)
             .and change { Reservation.count }.by(1)
          end
        end

        context "guest email already exist" do
          before :each do
            FactoryBot.create :guest, email: "wayne_woodbridge@bnb.com"
          end
          it "should only create reservation" do
            expect {
              reservation_service.create(playload_1_params)
            }.to change { Guest.count }.by(0)
             .and change { Reservation.count }.by(1)
          end
        end
      end

      context "invalid values" do
        it "should return nil and error" do
          playload_1_params["start_date"] = Date.current - 1.day
          reservation, error = reservation_service.create(playload_1_params)
          expect(reservation.id).to eq nil
          expect(error).not_to eq []
        end
      end
    end
  end

  describe ".parse_attributes" do
    context "params match to RESERVATION_PAYLOADS_MAPPER payload" do
      context "match payload 1" do
        it "should return attributes hash for guest and reservation" do
          attributes = reservation_service.parse_attributes(playload_1_params)
          expect(attributes.keys).to eq([:guest, :reservation])
        end
      end

      context "match payload 2" do
        it "should return attributes hash for guest and reservation" do
          attributes = reservation_service.parse_attributes(playload_2_params)
          expect(attributes.keys).to eq([:guest, :reservation])
        end
      end
    end

    context "params is empty" do
      let(:params) { {} }

      it "should return empty hash" do
        expect(reservation_service.parse_attributes(params)).to eq({})
      end
    end

    context "params does not match to RESERVATION_PAYLOADS_MAPPER payload" do
      let(:params) { {
        hello: { hi: "1234" }
      }.with_indifferent_access}

      it "should return empty hash" do
        expect(reservation_service.parse_attributes(params)).to eq({})
      end
    end
  end
end
