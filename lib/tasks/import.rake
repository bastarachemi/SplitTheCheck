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
      r.will_split = row["will_split"]
      r.wont_split = row["wont_split"]
      r.save
    end
  end
end
