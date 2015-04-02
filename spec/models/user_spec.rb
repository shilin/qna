require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:author) { create(:user) }
  let(:not_author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, user: author) }

  it 'checks if an author passes author_of? method for question and answer' do
    expect(author.author_of?(question)).to eq true
    expect(author.author_of?(answer)).to eq true
  end

  it 'checks if not an author fails author_of? method for question and answer' do
    expect(not_author.author_of?(question)).to eq false
    expect(not_author.author_of?(answer)).to eq false
  end
end
