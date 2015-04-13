require_relative '../feature_helper'

feature 'Only question author can name answer to be the best', %q(
In order to heil the answer
As a question author
A want to be able to call the answer to be the best
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  scenario 'Non-authorized user tries to name answer best' do
    visit question_path(question)

    expect(page).to_not have_content('Make it the best')
  end

  scenario 'Autorized user tries to name answer best' do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_content('Make it the best answer')
  end

  scenario 'Author calls the best answer', js: true do
    sign_in author
    visit question_path(question)

    save_and_open_page
    within(".answers_list #answer_#{answer.id}") do
      click_on 'Make it the best answer'
    end


  end
end

