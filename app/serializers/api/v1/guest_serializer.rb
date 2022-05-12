class Api::V1::GuestSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :phones
end
