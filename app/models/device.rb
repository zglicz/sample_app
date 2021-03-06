class Device < ActiveRecord::Base
	validates :user_id, :name, presence: true
	validates :name, length: { maximum: 10 }
	belongs_to :user
	has_many :movies, dependent: :destroy
end
