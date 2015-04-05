require 'rails_helper'

feature 'Only authenticated user can answer a question', %q(
  In order to give back to community
  As a user
  I want to be able to answer questions

) do
  context 'Unauthenticate user' do
    scenario 'fails to find a way to give an answer to a question', js: true do
      question = create(:question)
      visit question_path(question)
      expect(page).to_not have_button 'Submit'
    end
  end

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before do
      sign_in(user)
      question = create(:question)
      visit question_path(question)
    end

    scenario 'gives an invalid answer to a question', js: true do
      fill_in 'Body', with: nil
      click_on 'Submit'

      expect(page).to have_content 'Failed to save your answer!'
    end

    scenario 'gives a valid answer to a question', js: true do
      fill_in 'Body', with: 'My coolest answer'
      click_on 'Submit'

      expect(page).to have_content 'Your answer is saved successfully!'
      within('.answers_list') do
        expect(page).to have_content 'My coolest answer'
      end
    end
  end
end
