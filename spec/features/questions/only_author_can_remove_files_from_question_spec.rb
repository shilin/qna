require_relative '../feature_helper'

feature 'Only author can remove files attached to question', %q(
  In order to make answer better
  As an author
  I want to be able to remove bad files from question
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create :question, user: author }

  scenario 'Authenticated user tries to remove file from not his question', js: true do
    sign_in author
    visit questions_path

    click_on 'Ask a question'
    fill_in 'question_title', with: 'My question title'
    fill_in 'question_body', with: 'My question body'
    click_on 'Add file'
    attach_file :file, "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Submit'

    click_on 'Sign out'
    sign_in user
    click_on 'My question title'

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Author removes file from question', js: true do
    sign_in author
    visit questions_path

    click_on 'Ask a question'
    fill_in 'question_title', with: 'My question title'
    fill_in 'question_body', with: 'My question body'
    click_on 'Add file'
    attach_file :file, "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Submit'

    click_on 'Edit'
    click_on 'Remove file'

    within('.question') do
      all(:link_or_button, 'Submit')[0].click
    end

    expect(page).to_not have_content 'rails_helper.rb'
  end
end
