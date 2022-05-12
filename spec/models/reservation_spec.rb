require "rails_helper"

RSpec.describe Reservation, type: :model do
  context "associations" do
    it { should belong_to(:guest) }
  end

  context "RESERVATION_PAYLOADS_MAPPER" do
    it "should have all attribute_names mapped to payload keys" do
      RESERVATION_PAYLOADS_MAPPER.each do |_, payload|
        expect(Reservation.attribute_names).to include(*payload["reservation_fields_mapper"].keys)
      end
    end
  end

  context "validations" do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_numericality_of(:total_nights).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:total_nights).only_integer }
    it { should validate_numericality_of(:total_guests).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:total_guests).only_integer }
    it { should validate_numericality_of(:number_of_adults).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:number_of_adults).only_integer }
    it { should validate_numericality_of(:number_of_children).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:number_of_children).only_integer }
    it { should validate_numericality_of(:number_of_infants).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:number_of_infants).only_integer }
    it { should validate_numericality_of(:payout_price).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:security_price).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:total_price).is_greater_than_or_equal_to(0) }

    context "start_date and end_date" do
      let(:reservation) { FactoryBot.build :reservation }

      it "valid when start_date is before end_date" do
        reservation.start_date = Date.current + 1.day
        reservation.end_date = Date.current + 2.day
        expect(reservation.valid?).to eq true
      end

      it "invalid when start_date is after end_date" do
        reservation.start_date = Date.current + 2.day
        reservation.end_date = Date.current + 1.day
        expect(reservation.valid?).to eq false
      end

      it "invalid when start_date before current" do
        reservation.start_date = Date.current - 2.day
        reservation.end_date = Date.current + 1.day
        expect(reservation.valid?).to eq false
      end

      it "invalid when start_date before current" do
        reservation.start_date = Date.current - 2.day
        reservation.end_date = Date.current - 1.day
        expect(reservation.valid?).to eq false
      end
    end
  end
end
