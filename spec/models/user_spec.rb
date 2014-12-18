require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:valid_attributes) { {
    name: "Viki",
    email_address: "viki@example.com",
    password: "password",
    password_confirmation: "password"
    } }

    let(:invalid_attributes) { {
      name: nil,
      email_address: nil,
      password: nil,
      password_confirmation: nil
      } }

  describe "user attributes" do
    it "must have valid_attributes" do
      user = User.create(valid_attributes)
      invalid_user = User.create(invalid_attributes)
      expect(user).to be_valid
      expect(invalid_user).to_not be_valid
    end

    it "should not have an implausible email address" do
      user = User.create(name: "Viki",
        email_address: "fsodubdfjb",
        password: "password",
        password_confirmation: "password")
      expect(user).to_not be_valid

      user = User.create(name: "Viki",
      email_address: "viki@example,com",
      password: "password",
      password_confirmation: "password")
      expect(user).to_not be_valid

      user = User.create(name: "Viki",
      email_address: "viki_at_example.com",
      password: "password",
      password_confirmation: "password")
      expect(user).to_not be_valid
    end

    it "should have a unique email address" do
      user = User.create(name: "Viki",
      email_address: "viki@example.com",
      password: "password",
      password_confirmation: "password")

      user2 = User.create(name: "Viki",
      email_address: "viki@example.com",
      password: "password",
      password_confirmation: "password")

      expect(user).to be_valid
      expect(user2).to_not be_valid
    end

    it "must have a name" do
      user = User.create(name: "",
      email_address: "viki@example.com",
      password: "password",
      password_confirmation: "password")
      expect(user).to_not be_valid
    end

    it "can have an optional display name" do
      user = User.create(name: "Viki",
      email_address: "viki1@example.com",
      password: "password",
      password_confirmation: "password")
      expect(user).to be_valid

      valid_attributes[:display_name] = "viki"
      user = User.create(valid_attributes)
      expect(user).to be_valid
      expect(user.display_name).to eq("viki")
    end

    it "cannot have a display name under 2 characters" do
      user = User.create(name: "Viki",
      email_address: "viki@example.com",
      display_name: "v",
      password: "password",
      password_confirmation: "password")
      expect(user).to_not be_valid
    end

  end

  describe "relationships" do
    let(:user) { User.create(valid_attributes) }

    it "can have many reservations" do
      date = Date.today
      reservation = Reservation.create( property_id: 1,
                                        start_date: date,
                                        end_date: date.advance(days: 4),
                                        user: user)
      reservation2 = Reservation.create( property_id: 1,
                                        start_date: date,
                                        end_date: date.advance(days: 11),
                                        user: user)

      expect(user.reservations.first).to eq(reservation)
      expect(user.reservations.last).to eq(reservation2)
      expect(user.reservations.count).to eq(2)
    end

  end
end
