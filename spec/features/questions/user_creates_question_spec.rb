require 'rails_helper'

feature 'User can create a question', %q{

  In order to get help from community
  As a user
  I want to be able to create questions
} do

  scenario 'User creates a valid question' do
    visit new_question_path
    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'
    click_on 'Submit'
    expect(page).to have_content 'Question successfully created'
  end

  scenario 'User tries to create an invalid question' do
    visit new_question_path
    fill_in 'Title', with: 'Title'
    click_on 'Submit'
    expect(page).to have_content 'Failed to create question'

  end
  #scenario 'Authenticated user creates a question' do
  #  User.create!(email: 'user@test.com', password: '12345678')
  #  visit new_user_session_path
  #  fill_in 'Email', with: 'user@test.com'
  #  fill_in 'Password', with: '12345678'
  #  click_on 'Log in'

  #  expect(page).to have_content 'Signed in successfully'
  #  expect(current_path).to eq root_path
  #end


end
