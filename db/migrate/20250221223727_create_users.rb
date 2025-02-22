class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :phone_number, null: false
      t.boolean :phone_verified, default: false, null: false
      t.string :verification_code
      t.datetime :verification_code_expires_at

      t.timestamps
    end

    add_index :users, :phone_number, unique: true
  end
end
