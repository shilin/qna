require_relative '../feature_helper'

feature 'User can sign up', %q(
  In order to ask questions
  As a user
  I want to be able to sign up

) do
  given(:user) { create(:user) }

  scenario 'Non-registered user signs up' do
    visit root_path
    click_on 'Sign up'

    fill_in 'user_email', with: 'user@test.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully'
  end
  scenario 'Already registered user tries signs up' do
    visit root_path
    click_on 'Sign up'

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Non-registered user fails to confirm password' do
    visit root_path
    click_on 'Sign up'

    fill_in 'user_email', with: 'test@user.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '127'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
