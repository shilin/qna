require_relative '../feature_helper'

feature 'User can add files to his question', %q(
  In order to illustrate my question
  As an author
  I can add files to the question
) do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }


 # context 'On show question page' do
 #   scenario 'Non authenticated user tries to add file to a question' do
 #     visit question_path(question)

 #     within('.question') do
 #       expect(page).to_not have_content 'Attach file'
 #     end
 #   end

 #   scenario 'Authenticated user tries to add file to not his own question' do
 #     sign_in user
 #     visit question_path(question)

 #     within('.question') do
 #       expect(page).to_not have_content 'Attach file'
 #     end
 #   end

 #   scenario 'Author adds file to his question' do
 #     sign_in author
 #     visit question_path(question)

 #     within('.question') do
 #       expect(page).to have_link 'Attach file'
 #     end
 #   end
 # end

  context 'On new question page' do
    scenario 'Non authenticated user tries to add file to a question' do
      # subset of non auth user can ask a question feature
    end

    scenario 'User creates question and adds file to his question' do
      sign_in author
      visit new_question_path

      fill_in :question_title, with: 'My question title'
      fill_in :question_body, with: 'My question body'
      attach_file 'file', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Submit'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

  end

end
