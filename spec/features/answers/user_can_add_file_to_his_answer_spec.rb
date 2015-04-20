require_relative '../feature_helper'

feature 'User can add files', %q(
  In order to illustrate my answer
  As a user
  I want to be able to add files to my answer
) do

  given(:question) { create(:question) }
  given(:user) { create(:user) }
#  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user adds file when giving answer', js: true do
    sign_in user
    visit question_path(question)

    within('form.new_answer') do
      fill_in :answer_body, with: 'My answer'
      attach_file :file, "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Submit'
    end

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end

end
