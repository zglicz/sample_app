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

	forbidden_words = Regexp.union('dvd', 'rip', 'unrated', '720p', '1080p',
		'xvid', 'ac3', 'scr', 'bluray', 'limited')

	def process_folder_name(folder_name)
		res = folder_name.dup
		res.gsub!(/\./, ' ')
		first_pos = res.index(/[\[\]()]|(\d{4})/)
		res = res[0, first_pos].strip if first_pos
		res
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
	end
end