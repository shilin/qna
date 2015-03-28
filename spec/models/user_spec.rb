require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many :questions }
  it { should have_many :answers }

  let!(:user) { create(:user) }

  before do
    @thing = Object.new

    @thing.class_eval { attr_writer :user }

    def @thing.user_id
      @user.id
    rescue
      nil
    end
  end

  it 'checks if an author passes author_of? method' do
    @thing.user = user
    expect(user.author_of?(@thing)).to eq true
  end

  it 'checks if not an author fails author_of? method' do
    expect(user.author_of?(@thing)).to eq false
  end
end
