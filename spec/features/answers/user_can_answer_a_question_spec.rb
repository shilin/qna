require 'rails_helper'

feature 'User can answer a question', %q{
In order to give back to community
As a user
I want to be able to answer questions
} do


  scenario 'User gives a valid answer to a question' do
    question = create(:question)
    visit question_path(question)
    fill_in 'Body', with: 'MyAnswer'
    click_on 'Submit'
    expect(page).to have_content 'Your answer is saved successfully!'
  end

  scenario 'User gives an invalid answer to a question' do
    question = create(:question)
    visit question_path(question)
    fill_in 'Body', with: nil
    click_on 'Submit'
    expect(page).to have_content 'Failed to save your answer!'

  end

end
