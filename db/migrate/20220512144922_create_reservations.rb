class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations, id: :uuid do |t|
      t.uuid    :guest_id
      t.date    :start_date
      t.date    :end_date
      t.integer :status
      t.string  :currency
      t.decimal :payout_price, precision: 8, scale: 2
      t.decimal :security_price, precision: 8, scale: 2
      t.decimal :total_price, precision: 8, scale: 2
      t.integer :total_nights
      t.integer :total_guests, default: 0
      t.integer :number_of_adults, default: 0
      t.integer :number_of_children, default: 0
      t.integer :number_of_infants, default: 0

      t.timestamps
    end

    add_index :reservations, :guest_id
  end
end
