module MoviesHelper
	def sortable(column, title = nil)
		title ||= column.titleize
		css_class = column == sort_column ? "current #{sort_direction}" : nil
		direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
		link_to title,
			params.merge(:sort => column, :direction => direction, :page => nil),
			{:class => css_class}
	end

	def get_movies(owner)
		owner.movies.search(params[:search]).order(sort_column + " " + sort_direction).paginate(page: params[:page])
	end

	def sort_column
		Movie.column_names.include?(params[:sort]) ? params[:sort] : "name"
	end

	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
	end

	def match_all
		movies = @user.movies.where(tagged: false)
		how_many = 0
		movies.each do |movie|
			movie_data = search_by_name(movie.folder_name)
			puts "looking for: #{movie.folder_name}"
			next unless movie_data
			first_data = movie_data.first
			next unless first_data
			update_data(movie, first_data['imdbID'])
			how_many += 1
		end
		how_many
	end

	def search_by_id(imdb_id)
		imdb_search_object = IMDB.new(imdb_id).info
		imdb_search = JSON.parse imdb_search_object.body
		imdb_search
	end

	def search_by_name(folder_name)
		imdb_search_object = IMDB.new(process_folder_name(folder_name)).search
		hashyk = JSON.parse imdb_search_object.body
		imdb_search = hashyk['Search']
		imdb_search = imdb_search.find_all{ |movie| movie['Type'] == "movie"} if imdb_search
		imdb_search
	end

	def update_data(movie, imdb_id)
		data = search_by_id(imdb_id)
		movie.name = data['Title']
		movie.imdb_id = data['imdbID']
		movie.year = data['Year']
		movie.tagged = true
		movie.save
	end

	def process_folder_name(folder_name)
		forbidden_words = Regexp.union('dvd', 'rip', 'unrated', '720p', '1080p',
			'xvid', 'ac3', 'scr', 'bluray', 'limited', 'extended')
		forbidden_search = Regexp.new(forbidden_words.source, Regexp::IGNORECASE)
		res = folder_name.dup
		res.gsub!(/\./, ' ')
		first_pos = res.index(/[\[\]()]|(\d{4})/)
		res = res[0, first_pos].strip if first_pos
		words = res.split(' ')
		bad_index = words.find_index{ |word| word =~ forbidden_search }
		words = words[0, bad_index] if bad_index
		res = words.join(' ')
	end

	# for api calls
	class IMDB
		include HTTParty
		base_uri 'http://www.omdbapi.com/'

		def initialize(name)
			@name = name
		end

		def search(limit=10)
			self.class.get('/', :query => { :s => @name })
		end

		def info
			self.class.get('/', :query => { :i => @name })
		end
	end
end