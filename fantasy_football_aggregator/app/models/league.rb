class League < ActiveRecord::Base
  #This will all be automatically created with mechanize in later versions
  validates :account_id, :presence => true
  validates :league_number, :presence => true, :uniqueness => {:scope => [:account]}
  validates :name, :presence => true, :uniqueness => {:scope => :league_number}
  validates :team_number, :presence => true

  belongs_to :account
end
