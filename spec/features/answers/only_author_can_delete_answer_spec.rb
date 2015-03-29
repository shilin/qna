require 'rails_helper'

feature 'Only author can delete answer', %q(
  In order to fix things
  As an author
  I want to be able to delete my answer

) do
  given(:not_author) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Not an author tries to delete an answer' do
    sign_in(not_author)

    visit question_path(question)
    within("#answer_#{answer.id}") do
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Author deletes his own answer' do
    sign_in(author)

    visit question_path(question)
    within("#answer_#{answer.id}") do
      click_on 'Delete'
    end

    expect(page).to have_content 'Answer has been removed'
    expect(page).to_not have_content "#{answer.body}"
  end
end
