class Account < ActiveRecord::Base
  validates :platform, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_name, :presence => true
  validates :password, :presence => true

  belongs_to :user
  has_many :leagues, :dependent => :destroy
end
