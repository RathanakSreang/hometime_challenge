require "rails_helper"

RSpec.describe "BaseService" do
  let(:base_service) { BaseService.new }

  describe ".array_contain_all?" do
    it "should return false if any parameters nil" do
      expect(base_service.array_contain_all?(nil, nil)).to eq false
      expect(base_service.array_contain_all?([1, 2, 3], nil)).to eq false
      expect(base_service.array_contain_all?(nil, [1, 2, 3])).to eq false
    end

    it "should return false if second parameter not all contain in first arr parameters" do
      expect(base_service.array_contain_all?([1, 2, 3], [2, 4])).to eq false
    end

    it "should return true if second parameter all in first arr parameters" do
      expect(base_service.array_contain_all?([1, 2, 3], [2, 3])).to eq true
      expect(base_service.array_contain_all?([1, 2, 3], [1, 2, 3])).to eq true
    end
  end

  describe ".mapping_attributes" do
    let(:params) { {
      hello: {
        hi: "1234"
      },
      home: "12345"
    }.with_indifferent_access}
    let(:mapper) { {
      field_1: { field: "hello.hi" },
      field_2: { field: "home" }
    }}

    it "should get value from params via mapping" do
      attributes = base_service.mapping_attributes(params, mapper)
      expect(attributes.class).to eq ActiveSupport::HashWithIndifferentAccess
      expect(attributes.keys).to include("field_1", "field_2")
      expect(attributes["field_1"]).to eq "1234"
      expect(attributes["field_2"]).to eq "12345"
    end

    context "array field" do
      let(:base_service) { BaseService.new }
      let(:params) { {
        hello: {
          hi: ["1234", "2345"]
        },
        home: "12345"
      }.with_indifferent_access}
      let(:mapper) { {
        field_1: { field: "hello.hi", is_array: true },
        field_2: { field: "home", is_array: true }
      }}

      it "should return array value from params via mapping" do
        attributes = base_service.mapping_attributes(params, mapper)
        expect(attributes.class).to eq ActiveSupport::HashWithIndifferentAccess
        expect(attributes.keys).to include("field_1", "field_2")
        expect(attributes["field_1"]).to eq ["1234", "2345"]
        expect(attributes["field_2"]).to eq ["12345"]
      end
    end
  end
end
