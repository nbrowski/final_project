class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :platform
      t.string :password
      t.string :user_name
      t.integer :user_id

      t.timestamps

    end
  end
end
