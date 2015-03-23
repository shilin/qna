require 'rails_helper'

RSpec.describe AnswersController, type: :controller do



  describe 'GET #show' do

    let(:question) {create(:question)}
    let(:answer) {create(:answer)}

    before {get :show, question_id: question, id: answer}
    it 'Assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

  end

  describe 'POST #create' do

    let(:question) {create(:question)}

    context "Authenticated user" do

      before { sign_in_user }
      context 'creates an answer with valid attributes' do
        it 'saves answer that belongs to the question' do
          expect do
            post :create, answer: attributes_for(:answer), question_id: question
          end.to change(question.answers, :count).by(1)
        end

        it 'redirects to show' do
          post :create, answer: attributes_for(:answer), question_id: question
          expect(response).to redirect_to [question, assigns(:answer)]
        end

      end

      context 'tries to create an answer with invalid attributes' do
        it 'fails to save an invalid answer into db' do
          expect {post :create, answer: attributes_for(:invalid_answer), question_id: question}.to_not change(Answer, :count)
        end
        it 're-renders new template' do
          post :create, answer: attributes_for(:invalid_answer), question_id: question
          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user' do
      context 'tries to create an answer with valid attributes' do
        it 'fails to save the answer that belongs to the question' do
          expect do
            post :create, answer: attributes_for(:answer), question_id: question
          end.to_not change(question.answers, :count)
        end
        it 'redirects to sign in page' do
          post :create, answer: attributes_for(:answer), question_id: question
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

  end
end
