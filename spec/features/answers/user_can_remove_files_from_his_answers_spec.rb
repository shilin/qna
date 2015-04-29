require_relative '../feature_helper'

feature 'User can remove files from his older answers', %q(
  In order to clean the answer from wrong files
  As an author
  I want to be able to remove wrong files from my answer
) do

  given(:author) { create :user }
  given(:user) { create :user }
  given(:question) { create :question }


  before do
    sign_in author
    visit question_path(question)

    within('form.new_answer') do
      fill_in :answer_body, with: 'My answer'
      click_on 'Add file'
      attach_file :file, "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Add file'
    end

    within all('.fields').last do
      attach_file :file, "#{Rails.root}/spec/spec_helper.rb"
    end

    within ('form.new_answer') do
      click_on 'Submit'
    end
  end

  scenario 'Guest tries to remove files from an answer', js: true do

    click_on 'Sign out'
    visit question_path(question)

    within('.answers_list') do
      expect(page).to_not have_link 'Edit'
    end

  end

  scenario 'Authenticated user tries to remove files not from his answer', js: true do

    click_on 'Sign out'
    sign_in user
    visit question_path(question)

    within('.answers_list') do
      expect(page).to_not have_link 'Edit'
    end

  end

  scenario 'Author removes files from answer', js: true do

    within('.answers_list') do
      click_on 'Edit'
    end

    within all('.answers_list .fields').first do
      click_on 'Remove file'
    end

    within ('.answers_list .edit_answer') do
      all(:link_or_button, 'Submit')[0].click
    end

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    expect(page).to_not have_content 'spec_helper.rb'

  end
end
