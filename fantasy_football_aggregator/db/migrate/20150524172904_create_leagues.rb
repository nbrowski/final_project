class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.integer :team_number
      t.string :name
      t.integer :league_number
      t.integer :account_id

      t.timestamps

    end
  end
end
