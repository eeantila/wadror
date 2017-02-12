require 'rails_helper'

describe "Beers page" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end


  it "can add valid beer" do
    visit new_beer_path
    fill_in('beer[name]', with:"Testi")

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "cannot add invalid beer and shows error message" do
    visit new_beer_path
    fill_in('beer[name]', with:"")

    expect{
      click_button "Create Beer"
    }.to_not change{Beer.count}
    expect(page).to have_content "Name can't be blank"
  end


end