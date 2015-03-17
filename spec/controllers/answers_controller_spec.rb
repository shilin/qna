require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'POST #create' do

    let(:question) {create(:question)}

    context 'with valid attributes' do
      it 'saves an answer into db' do
        expect do 
          post :create, answer: attributes_for(:answer), question_id: question
        end.to change(question.answers, :count).from(0).to(1)
      end

      it 'saves answer that belongs to the question' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(question.answers.first).to eq assigns(:answer)

      end
      it 'redirects to show' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to [question, assigns(:answer)]
      end

    end

    context 'with invalid attributes' do
      it 'fails to save an invalid answer into db' do
        expect {post :create, answer: attributes_for(:invalid_answer), question_id: question}.to_not change(Answer, :count)
      end
      it 're-renders new template' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template :new
      end
    end

  end

end
