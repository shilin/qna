require 'rails_helper'

feature 'User can create a question', %q{

  In order to get help from community
  As a user
  I want to be able to create questions
} do

  scenario 'User creates a valid question' do
    visit questions_path
    click_on 'Ask a question'
    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'
    click_on 'Submit'
    expect(page).to have_content 'Question successfully created'
  end

  scenario 'User tries to create an invalid question' do
    visit questions_path
    click_on 'Ask a question'
    fill_in 'Title', with: 'Title'
    click_on 'Submit'
    expect(page).to have_content 'Failed to create question'

  end


end
