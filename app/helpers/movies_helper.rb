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
end