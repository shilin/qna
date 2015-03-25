require 'rails_helper'

feature 'Only author can delete question', %q{
  In order to fix things
  As an author
  I want to be able to delete my question
} do

  given(:author) {create(:user)}
  given(:question) {create(:question, user: author)}
  given(:not_author) {create(:user)}

  scenario 'Not an author deletes a question' do
    sign_in(not_author)
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_content 'Failed to remove the question'
  end

  scenario 'author deletes a question' do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_content 'Question has been removed'
  end

end
