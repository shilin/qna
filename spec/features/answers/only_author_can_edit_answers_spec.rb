require_relative '../feature_helper'

feature 'Only author can edit answers', %q(
In order to fix answers
As an author
I should be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated user tries to edit an answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  scenario 'Authenticated user tries to edit another user answer' do
    sign_in user
    visit question_path(question)

    within('.answer') do
      expect(page).to_not have_link 'Edit'
    end
  end

  context 'Author' do
    before do
      sign_in author
      visit question_path(question)
    end

    scenario 'sees edit link for his own answer' do
      within("#answer_#{answer.id}") do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'edits his own answer', js: true do
      within("#answer_#{answer.id}") do
        click_on 'Edit'
      end
      within("form#edit_answer_#{answer.id}") do
        fill_in 'answer_body', with: 'my coolest answer'
        click_on 'Submit'
      end

      expect(page).to have_content 'my coolest answer'
      expect(page).to_not have_content answer.body
      expect(page).to_not have_selector "#answer_#{answer.id} textarea"
    end
  end
end
