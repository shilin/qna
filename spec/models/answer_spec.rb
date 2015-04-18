require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:attachments).dependent(:destroy)}
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_presence_of :user }

  it { should accept_nested_attributes_for :attachments }

  context 'answer made best' do
    it 'ensures all question best answer(s) are made false before successfully setting/unsetting new best' do
      question = create(:question)
      answer1 = create(:answer, question: question, best: true)
      answer2 = create(:answer, question: question)

      answer2.update!(best: true)

      expect(answer2.best).to eq true
      expect(answer1.reload.best).to eq false
    end
  end
end
