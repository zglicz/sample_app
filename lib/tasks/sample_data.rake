namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
                         email: "example@railstutorial.org",
                         password: "foobar",
                         password_confirmation: "foobar",
                         admin: true)
    10.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 5)
    users.each do |user| 
      5.times do
        name = Faker::Name.first_name()
        description = Faker::Lorem.sentence(5)
        device = user.devices.create!(name: name, description: description)
        10.times do |num|
          folder_name = "movie#{num}"
          device.movies.create!(folder_name: folder_name, user: user, name: folder_name,
                no_of_files: 0, total_size: 0, imdb_id: "<>", tagged: false)
        end
      end
    end
  end
end