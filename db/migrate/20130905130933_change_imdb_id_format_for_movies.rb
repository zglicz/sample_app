class ChangeImdbIdFormatForMovies < ActiveRecord::Migration
  def change
  	change_column :movies, :imdb_id, :string
  end
end
