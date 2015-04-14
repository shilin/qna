require_relative '../feature_helper'

feature 'Only question author can name answer to be the best', %q(
In order to heil the answer
As a question author
A want to be able to call the answer to be the best
) do
  given!(:question_author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question, best: true) }

  scenario 'Non-authorized user sees the best answer first', js: true do
    visit question_path(question)
    expect(first('ul.answers_list li')).to have_content answer2.body
  end

  scenario 'Non-authorized user tries to name answer best', js: true do
    visit question_path(question)

    expect(page).to_not have_content('Make it the best')
  end

  scenario 'Autorized user tries to name answer best' do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_content('Make it the best answer')
  end

  scenario 'Question author assigns new best answer', js: true do
    sign_in question_author
    visit question_path(question)

    find(".answers_list #answer_#{answer1.id} a").click
    sleep 1

    expect(first('.answers_list li')).to have_content answer1.body
  end
end
