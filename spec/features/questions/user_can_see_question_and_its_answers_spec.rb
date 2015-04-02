require 'rails_helper'

feature 'User can view a question and all its answers', %q(
  In order to get info from a question and its answers
  As a user
  I want to be able to view a question and all its answers
    ) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user) }

  scenario 'User visits a question page' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer1.body
    expect(page).to have_content answer2.body
  end
end
