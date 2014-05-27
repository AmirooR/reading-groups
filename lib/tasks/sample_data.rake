namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Amir Rahimi",
                 email: "noname01.cpp@gmail.com",
		 email_confirmation: "noname01.cpp@gmail.com",
		 login: "noname01",
                 password: "1234.1234",
                 password_confirmation: "1234.1234", admin: true)
    99.times do |n|
      name  = Faker::Name.name
      first_name = Faker::Name.first_name
      login = "#{first_name}#{n+1}"
      email = "example-#{n+1}@readinggroups.com"
      password  = "password1234"
      User.create!(name: name,
                   email: email,
		   email_confirmation: email,
		   login: login,
                   password: password,
                   password_confirmation: password)
    end
  end
end
