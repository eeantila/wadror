require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do

    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "shows user's and only user's ratings on user page" do
      FactoryGirl.create :user, username:"Matti"
      sign_in(username:"Pekka", password:"Foobar1")
      FactoryGirl.create :beer
      FactoryGirl.create :rating, user_id:1, beer_id:1
      FactoryGirl.create :rating2, user_id:1, beer_id:1
      FactoryGirl.create :rating, score:15, user_id:2, beer_id:1

      visit user_path(1)

      expect(page).to have_content 'Has made 2 ratings'
      expect(page).to have_content 'Pekka'
      expect(page).to have_content 'anonymous 10'
      expect(page).to have_content 'anonymous 20'
      expect(page).to_not have_content 'Matti'
      expect(page).to_not have_content 'anonymous 15'
    end

    it "properly deletes rating" do
      sign_in(username:"Pekka", password:"Foobar1")
      FactoryGirl.create :beer
      FactoryGirl.create :rating, user_id:1, beer_id:1
      FactoryGirl.create :rating2, user_id:1, beer_id:1

      visit user_path(1)
      page.first(:link, "delete").click

      expect(page).to_not have_content 'anonymous 10'
      expect(page).to have_content 'anonymous 20'
      expect(Rating.count).to eq(1)
    end

  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

end