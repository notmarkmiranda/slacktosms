class CreateSlackConnections < ActiveRecord::Migration[8.0]
  def change
    create_table :slack_connections do |t|
      t.references :user, null: false, foreign_key: true
      t.string :slack_user_id, null: false
      t.string :access_token, null: false
      t.string :team_id, null: false
      t.string :team_name, null: false

      t.timestamps
    end

    add_index :slack_connections, [ :user_id, :team_id ], unique: true
  end
end
