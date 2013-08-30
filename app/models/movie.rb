class Movie < ActiveRecord::Base
	validates :user_id, :device_id, :folder_name, presence: true

	belongs_to :user
	belongs_to :device

	def self.import(owning_device, file)
		owning_device.movies.destroy_all
		puts owning_device.inspect
		CSV.foreach(file.path, headers: true) do |row|
			new_movie = owning_device.movies.new(name: row["folder_name"],
								folder_name: row["folder_name"],
								no_of_files: row["no_of_files"],
								total_size: row["total_size"].to_i / 1.megabyte,
								imdb_id: "<>",
								tagged: false,
								user_id: owning_device.user_id)
			new_movie.save
		end
	end

	def self.search(search)
		if search
			where('name LIKE ?', "#{search}%")
		else
			all
		end
	end
end
