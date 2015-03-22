require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As a user
  I want to be able to sign up
} do


  scenario 'Non-registered user signs up' do
    visit root_path
    click_on 'Sign up'

    fill_in 'user_email', with: 'user@test.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully'

  end

  scenario 'Non-registered user provides fails to confirm password' do

    visit new_user_registration_path
    fill_in 'user_email', with: 'test@user.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '127'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  #  User.create!(email: 'user@test.com', password: '12345678')
  #  visit new_user_session_path
  #  fill_in 'Email', with: 'user@test.com'
  #  fill_in 'Password', with: '12345678'
  #  click_on 'Log in'

  #  expect(page).to have_content 'Signed in successfully'
  #  expect(current_path).to eq root_path
  #end
end
