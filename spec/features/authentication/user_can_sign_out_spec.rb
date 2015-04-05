require_relative '../feature_helper'

feature 'User can sign out', %q(
  In order to protect my privacy
  As a user
  I want  be able to sign out

) do
  let(:user) { create :user }
  scenario 'Logged in user signs out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully'
  end
end
