require 'rails_helper'

feature 'Only author can delete question', %q(
  In order to fix things
  As an author
  I want to be able to delete my question

) do
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:not_author) { create(:user) }

  scenario 'Non-authenticated user tries to delete a question' do
    visit question_path(question)
    within("#question_#{question.id}") do
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Not an author tries to delete a question' do
    sign_in(not_author)
    visit question_path(question)
    within("#question_#{question.id}") do
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'author deletes a question' do
    sign_in(author)
    visit question_path(question)
    within("#question_#{question.id}") do
      click_on 'Delete'
    end
    expect(page).to have_content 'Question has been removed'
    expect(page).to_not have_content 'MyQuestionText'
  end
end
