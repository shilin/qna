require 'rails_helper'

feature 'User can sign in', %q{

  In order to ask questions and view answers
  As a user
  I want to be able to sign in
} do

  given!(:user) {create(:user) }

  scenario 'Registered user tries to sign in' do
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'Non-registered user tries to sign in' do
    visit new_user_session_path
    fill_in 'user_email', with: 'wrong@test.com'
    fill_in 'user_password', with: '1234'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password'
  end


end
