require_relative '../feature_helper'

feature 'User can see questions list', %q(
In order to find answers to related question
As a user
I want to be able to see list of all questions

) do
  scenario 'User goes to questions page' do
    @questions = create_list(:question, 3)
    visit questions_path
    expect(current_path).to eq questions_path
    expect(page).to have_content 'List of questions'
    @questions.each { |q| expect(page).to have_content q.title }
  end
end
