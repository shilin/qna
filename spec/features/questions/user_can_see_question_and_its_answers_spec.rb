require 'rails_helper'

feature 'User can view a question and all its answers', %q(
  In order to get info from a question and its answers
  As a user
  I want to be able to view a question and all its answers
    ) do
  given(:question) { create(:question) }

  scenario 'User visits a question page' do
    question.answers.create(body: 'MyAnswerbody1')
    question.answers.create(body: 'MyAnswerbody2')
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content 'MyAnswerbody1'
    expect(page).to have_content 'MyAnswerbody2'
  end
end
