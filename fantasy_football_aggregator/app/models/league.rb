class League < ActiveRecord::Base
  #This will all be automatically created with mechanize in later versions
  validates :account, :presence => true
  validates :league_number, :presence => true, :uniqueness => {:scope => [:account, :user_id]}
  validates :name, :presence => true, :uniqueness => {:scope => :league_number}
  validates :team_number, :presence => true

  belongs_to :account
end
