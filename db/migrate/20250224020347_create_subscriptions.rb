class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :slack_connection, null: false, foreign_key: true
      t.string :channel_id, null: false
      t.string :channel_name, null: false
      t.string :last_seen_message_ts
      t.boolean :is_private, default: false, null: false
      t.boolean :is_dm, default: false, null: false

      t.timestamps
    end
    add_index :subscriptions, [ :slack_connection_id, :channel_id ], unique: true
  end
end
