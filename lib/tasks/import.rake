namespace :import do
  desc "TODO"
  task csv_model: :environment do
    require "csv"
    csv_text = File.read(Rails.root.join("lib", "restaurant_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      r = Restaurant.new
      r.name = row["name"]
      r.city = row["city"]
      r.state = row["state"]
      r.save
    end

    require "csv"
    csv_text = File.read(Rails.root.join("lib", "user_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      u = User.new
      u.email = row["email"]
      u.password = row["password"]
      u.password_confirmation = row["password_confirmation"]
      u.save
    end

    csv_text = File.read(Rails.root.join("lib", "vote_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      r = Vote.new
      r.user_id = row["user_id"]
      r.restaurant_id = row["restaurant_id"]
      r.will_split = row["will_split"]
      r.save
    end
  end
end
