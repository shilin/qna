require_relative '../feature_helper'

feature 'User can add files', %q(
  In order to illustrate my answer
  As a user
  I want to be able to add files to my answer
) do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user adds several files when giving answer', js: true do
    sign_in user
    visit question_path(question)

    within('form.new_answer') do
      fill_in :answer_body, with: 'My answer'
      click_on 'Add file'
      attach_file :file, "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Add file'
    within all('.field').last do
      attach_file :file, "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Submit'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
  end
end
