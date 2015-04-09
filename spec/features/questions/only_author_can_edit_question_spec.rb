require_relative '../feature_helper'

RSpec.describe 'Only author can edit questions', %q(
In order to rephrase question
As an author
I should be able to edit my question
) do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user tries to edit an question' do
    visit question_path(question)

    within('.question') do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Authenticated user tries to edit another user question' do
    sign_in user
    visit question_path(question)

    within('.question') do
      expect(page).to_not have_link 'Edit'
    end
  end

  context 'Author' do
    before do
      sign_in author
      visit question_path(question)
    end

    scenario 'sees edit link for his own question' do
      within('.question') do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'edits his own question', js: true do
      within('.question') do
        click_on 'Edit'
        fill_in 'question_body', with: 'my coolest updated question'
        click_on 'Submit'
      end

      expect(page).to have_content 'my coolest updated question'
      expect(page).to_not have_content question.body
      expect(page).to_not have_selector '.question textarea'
    end
  end
end
