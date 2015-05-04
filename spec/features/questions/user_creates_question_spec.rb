require_relative '../feature_helper'

feature 'Only authenticated user can create a question', %q(

  In order to get help from community
  As a user
  I want to be able to create questions

) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit questions_path
      click_on 'Ask a question'
    end

    scenario 'creates a valid question' do
      fill_in 'title', with: 'My question title'
      fill_in 'body', with: 'My question body'
      click_on 'Submit'
      expect(page).to have_content 'Question successfully created'
      expect(page).to have_content 'My question title'
      expect(page).to have_content 'My question body'
    end

    scenario 'tries to creates an invalid question' do
      fill_in 'title', with: question.title
      fill_in 'body', with: nil
      click_on 'Submit'
      expect(page).to have_content 'Failed to create question'
    end
  end

  scenario 'Unauthorized user creates a valid question' do
    visit questions_path
    click_on 'Ask a question'
    expect(page).to have_content ' You need to sign in or sign up before continuing'
  end
end
