require 'rails_helper'

feature 'User can create a question', %q{

  In order to get help from community
  As a user
  I want to be able to create questions
} do

  scenario 'Authenticated user creates a question' do
    User.create!(email: 'user@test.com', password: '12345678')
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully'
    expect(current_page).to eq root_path
  end

  scenario 'Non-authenticate user creates a question'

end
