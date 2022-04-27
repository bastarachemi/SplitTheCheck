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
      v = Vote.new
      v.user_id = row["user_id"]
      v.restaurant_id = row["restaurant_id"]
      v.will_split = row["will_split"]
      v.save
    end

    csv_text = File.read(Rails.root.join("lib", "comment_data.csv"))
    csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
    csv.each do |row|
      c = Comment.new
      c.user_id = row["user_id"]
      c.restaurant_id = row["restaurant_id"]
      c.message = row["message"]
      c.save
    end
  end
end
