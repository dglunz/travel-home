require 'faker'
require 'factory_girl'
FactoryGirl.definition_file_paths = [Rails.root.join('spec', 'factories')]
FactoryGirl.find_definitions

class Seed
  def initialize
    generate_users
    generate_categories
    generate_properties
    generate_reservations
    generate_addresses
    generate_property_images
  end

  def generate_users
    @horace_user = FactoryGirl.create(:host,
      display_name: "Horace",
      name: "Horace Williams",
      email_address: "demo+horace@jumpstartlab.com",
      admin: true)

    @jorge_user = FactoryGirl.create(:host,
      display_name: "Jorge",
      name: "Jorge Tellez",
      email_address: "demo+jorge@jumpstartlab.com",
      admin: true)

    @traveler_user = FactoryGirl.create(:user,
      display_name: "Traveler",
      name: "Jim Jones",
      email_address: "travel@example.com")

    @hostess_user = FactoryGirl.create(:host,
      display_name: "Hostess",
      name: "Hostess Hosterson",
      email_address: "host@example.com")

    puts "Users generated"
  end

  def generate_categories
    @house     = FactoryGirl.create(:category, name: "House")
    @apartment = FactoryGirl.create(:category, name: "Apartment")
    @room      = FactoryGirl.create(:category, name: "Room")
    @cabin     = FactoryGirl.create(:category, name: "Cabin")
    @boat      = FactoryGirl.create(:category, name: "Boat")
    @balloon   = FactoryGirl.create(:category, name: "Balloon")
    @shack     = FactoryGirl.create(:category, name: "Shack")

    puts "Categories generated"
  end


  def generate_properties
    @hill_house = FactoryGirl.create(:property, title: "Hill House",
                    description: Faker::Lorem.sentence(2),
                    category: @house,
                    occupancy: 4,
                    user: @horace_user)

    @runs_house = FactoryGirl.create(:property, title: "Run's House",
                    description: Faker::Lorem.sentence(3),
                    category: @house,
                    occupancy: 9,
                    user: @jorge_user)

     @pauls_boutique = FactoryGirl.create(:property, title: "Paul's Boutique",
                    description: Faker::Lorem.sentence(3),
                    category: @apartment,
                    occupancy: 2,
                    user: @horace_user)

      @the_room = FactoryGirl.create(:property, title: "The Room",
                    description: Faker::Lorem.sentence(1),
                    category: @room,
                    occupancy: 1,
                    user: @horace_user)

      @log_cabin = FactoryGirl.create(:property, title: "Log Cabin",
                    description: Faker::Lorem.sentence(1),
                    category: @cabin,
                    occupancy: 12,
                    user: @horace_user)

    puts "Properties generated"
  end

  def generate_reservations

    date = Date.current.advance(days: 100)

    FactoryGirl.create(:reservation, user: @traveler_user,
                         property: @hill_house,
                         start_date: date,
                         end_date: date.advance(days: 4))


    FactoryGirl.create(:reservation, status: "completed",
                         user: @traveler_user,
                         property: @pauls_boutique,
                        start_date: date.advance(days:-30),
                        end_date: date.advance(days:-25))

    FactoryGirl.create(:reservation, status: "cancelled",
                        user: @jorge_user,
                        property: @the_room,
                        start_date: date.advance(days: -5),
                        end_date: date)

    FactoryGirl.create(:reservation, status: "reserved",
                        user: @traveler_user,
                        property: @runs_house,
                        start_date: date.advance(days: 10),
                        end_date: date.advance(days: 20))

    puts "Reservations generated"
  end

  def generate_addresses
    Property.all.each do |property|
      Address.create!(line_1: Faker::Address.street_address,
                      city: Faker::Address.city,
                      state: Faker::Address.state,
                      zip: Faker::Address.postcode,
                      country: Faker::Address.country
                     )
      property.address = Address.last
      property.save!
    end

    User.all.each do |user|
      Address.create!(line_1: Faker::Address.street_address,
                      city: Faker::Address.city,
                      state: Faker::Address.state,
                      zip: Faker::Address.postcode,
                      country: Faker::Address.country
                     )
      user.address = Address.last
      user.save!
    end
  puts "Addresses generated"

  end

  def generate_property_images
    image_path = Rails.root.join("app", "assets", "images")
    Photo.create!(image: File.open(image_path.join("ext_house_1.jpeg")), property: @hill_house, primary: true)
    Photo.create!(image: File.open(image_path.join("int_house_1.jpg")), property: @hill_house)
    Photo.create!(image: File.open(image_path.join("int_house_2.jpg")), property: @hill_house)

    Photo.create!(image: File.open(image_path.join("ext_house_2.jpg")), property: @runs_house, primary: true)
    Photo.create!(image: File.open(image_path.join("int_house_3.jpg")), property: @runs_house)

    Photo.create!(image: File.open(image_path.join("ext_apt_1.jpg")), property: @pauls_boutique, primary: true)
    Photo.create!(image: File.open(image_path.join("int_apt_1.jpg")), property: @pauls_boutique)
    Photo.create!(image: File.open(image_path.join("int_apt_2.jpg")), property: @pauls_boutique)
    Photo.create!(image: File.open(image_path.join("int_apt_3.jpg")), property: @pauls_boutique)

    Photo.create!(image: File.open(image_path.join("ext_room_1.jpg")), property: @the_room, primary: true)
    Photo.create!(image: File.open(image_path.join("int_room_1.jpg")), property: @the_room)

    Photo.create!(image: File.open(image_path.join("ext_cabin_1.jpg")), property: @log_cabin, primary: true)
  end
end

Seed.new
