class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.string :folder_name
      t.integer :no_of_files
      t.integer :total_size
      t.integer :imdb_id
      t.boolean :tagged
      t.integer :user_id
      t.integer :device_id

      t.timestamps
    end
    add_index :movies, [:user_id]
    add_index :movies, [:device_id]
    add_index :movies, [:device_id, :folder_name], unique: true
  end
end
