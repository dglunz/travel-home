require "rails_helper"

describe "can add things to the trip", type: :feature do
  let(:start_date) { 1.year.from_now }
  let(:end_date) { 1.year.from_now.advance(days: 5)}
  context "when logged out" do
    before(:each) do
      user = User.create!(name: "Sam I Am",
                          email_address: "samiam@example.com",
                          password: "password",
                          password_confirmation: "password")
      address = Address.create!(line_1: "fake as hell",
                      city: "fake as hell",
                      state: "fake as hell",
                      zip: "fake as hell",
                      country: "fake as hell")
      category = Category.create name: "test category"
      Property.create(title: "My Cool Home",
                      price: 1000,
                      description: "cool description",
                      category: category,
                      occupancy: 2,
                      address: address,
                      user: user)
      Property.create(title: "Another Home",
                      price: 500,
                      description: "lame description",
                      category: category,
                      occupancy: 1,
                      address: address,
                      user: user)
      Property.create(title: "A Retired Home",
                      price: 44500,
                      description: "retired description",
                      category: category,
                      occupancy: 12,
                      address: address,
                      user: user)
      visit properties_path
    end

    it "can add things to the trip" do
      visit cart_path
      expect(page).to_not have_content "My Cool Home"
      expect(page).to_not have_content "cool description"

      visit properties_path
      click_link_or_button "My Cool Home"
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"

      expect(page).to have_content "My Cool Home"
    end

    it "can remove things from the trip" do
      click_link_or_button "My Cool Home"
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"

      expect(page).to have_content "My Cool Home"
      click_link_or_button "Cancel My Trip"

      visit cart_path
      expect(page).to_not have_content "My Cool Home"
    end

    it "can't checkout without logging in" do
      click_link_or_button "My Cool Home"
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"

      visit cart_path
      expect(page).to_not have_link "Request Reservation"
      expect(page).to have_content "Log in"
    end

    it "continutes checkout after logging in" do
      User.create!(
        display_name: "Jorge",
        name: "Jorge Tellez",
        email_address: "test@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false,
        host: false)
      visit reservations_path
      expect(page).to_not have_content "My Cool Home"

      visit properties_path
      click_link_or_button "My Cool Home"
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"

      visit cart_path
      fill_in "email_address", with: "test@example.com"
      fill_in "password", with: "password"
      click_link_or_button "Login"
      expect(page).to have_content "My Cool Home"
      click_link_or_button "Pay"

      visit reservations_path
      expect(page).to have_content "My Cool Home"
    end

  end
end
