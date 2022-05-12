require "rails_helper"

RSpec.describe Guest, type: :model do
  context "associations" do
    it { should have_many(:reservations).dependent(:destroy) }
  end

  context "RESERVATION_PAYLOADS_MAPPER" do
    it "should have all attribute_names mapped to payload keys" do
      RESERVATION_PAYLOADS_MAPPER.each do |_, payload|
        expect(Guest.attribute_names).to include(*payload["guest_fields_mapper"].keys)
      end
    end
  end

  context "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:first_name).is_at_most(50) }
    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:last_name).is_at_most(50) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(254) }
    it { should validate_uniqueness_of(:email) }

    context "email" do
      context "invalid format" do
        it "should invalid guest" do
          guest = FactoryBot.build :guest
          expect(guest.valid?).to eq true

          invalid_addresses = %w[guest@example,com guest_at_foo.org guest.name@example.
            foo@bar_baz.com foo@bar+baz.com]
          invalid_addresses.each do |invalid_address|
            guest.email = invalid_address
            expect(guest.valid?).to eq false
          end
        end
      end

      context "valid format" do
        it "should valid guest" do
          guest = FactoryBot.build :guest
          expect(guest.valid?).to eq true

          valid_addresses = %w[guest@example.com guest@foo.COM A_US-ER@foo.bar.org
            first.last@foo.jp alice+bob@baz.cn]
          valid_addresses.each do |valid_address|
            guest.email = valid_address
            expect(guest.valid?).to eq true
          end
        end
      end
    end
  end

  describe "#find_by_email_or_initialize" do
    context "guest email found" do
      let!(:guest) { FactoryBot.create :guest, email: "exist@email.com" }

      it "should return guest" do
        exist_guest = Guest.find_by_email_or_initialize({
          email: "exist@email.com",
          first_name: "Home"
        })

        expect(exist_guest.new_record?).to eq false
        expect(exist_guest.id).to eq guest.id
      end
    end

    context "guest email not found" do
      it "should return init guest with passing value" do
        new_guest = Guest.find_by_email_or_initialize({
          email: "exist@email.com",
          first_name: "Home"
        })

        expect(new_guest.new_record?).to eq true
        expect(new_guest.id).to eq nil
        expect(new_guest.email).to eq "exist@email.com"
        expect(new_guest.first_name).to eq "Home"
      end
    end
  end
end
