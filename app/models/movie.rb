class Movie < ActiveRecord::Base
	validates :user_id, :device_id, :folder_name, presence: true

	belongs_to :user
	belongs_to :device
end
