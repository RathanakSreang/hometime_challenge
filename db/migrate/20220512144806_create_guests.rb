class CreateGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :guests, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phones, array: true

      t.timestamps
    end

    add_index :guests, :email, unique: true
  end
end
