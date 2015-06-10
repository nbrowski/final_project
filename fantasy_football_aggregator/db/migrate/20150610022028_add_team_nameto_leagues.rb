class AddTeamNametoLeagues < ActiveRecord::Migration
  def change
    add_column :Leagues, :teamname, :string
  end
end
