require 'rails_helper'

feature 'Only author can delete answer', %q{
  In order to fix things
  As an author
  I want to be able to delete my answer
} do

  given(:not_author) {create(:user)}
  given(:author) {create(:user)}
  given(:question) {create(:question)}
  given!(:answer) {create(:answer, question: question, user: author)}

  scenario 'Not an author deletes an answer' do
    sign_in(not_author)
    visit question_path(question)
    within('div.answers') do
      click_on 'Delete'
    end
    expect(page).to have_content 'Failed to remove the answer'
  end

end

