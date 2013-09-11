FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
    	admin true
    end
  end

  factory :device do
  	sequence(:name) { |n| "Device ##{n}" }
  	sequence(:description) { |n| "Super device no. #{n}"}
  	user
  end

  factory :movie do
    sequence(:folder_name) { |n| "MyFolderName#{n}"}
    name "Normal name"
    no_of_files 0
    total_size 0
    imdb_id "<>"
    tagged false
    year 0
    user
    device
  end
end