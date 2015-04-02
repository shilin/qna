require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #show' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }

    before { get :show, question_id: question, id: answer }
    it 'Assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'Authenticated user' do
      before { sign_in_user }
      context 'creates an answer with valid attributes' do
        it 'saves answer that belongs to the question' do
          expect do
            post :create, answer: attributes_for(:answer), question_id: question, format: :js
          end.to change(question.answers, :count).by(1)
        end

        it 'saves answer that belongs to the current user' do
          expect do
            post :create, answer: attributes_for(:answer), question_id: question, format: :js
          end.to change(@user.answers, :count).by(1)
        end

        it 'adds the answer to the question show view' do
          post :create, answer: attributes_for(:answer), question_id: question, format: :js
          expect(response.status).to eq 200
        end
      end

      context 'tries to create an answer with invalid attributes' do
        it 'fails to save an invalid answer into db' do
          expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
        end
        it 'renders create.js template' do
          post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
          expect(response).to render_template 'create'
        end
      end
    end

    context 'Unauthenticated user' do
      context 'tries to create an answer with valid attributes' do
        it 'fails to save the answer that belongs to the question' do
          expect do
            post :create, answer: attributes_for(:answer), question_id: question, format: :js
          end.to_not change(question.answers, :count)
        end
        it 'responses with not authorized status' do
          post :create, answer: attributes_for(:answer), question_id: question, format: :js
          expect(response.status).to eq 401
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: author) }

    before { answer }
    context 'Unauthenticated user' do
      it 'tries to delete an answer' do
        expect { delete :destroy, id: answer, question_id: question }.to_not change(Answer, :count)
      end
      it 'redirects to sign_in' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Authenticated user' do
      it 'tries to delete an answer' do
        sign_in_user
        expect { delete :destroy, id: answer, question_id: question }.to_not change(Answer, :count)
      end
      it 'tries to delete an answer and redirected' do
      end
    end

    context 'Author' do
      it 'tries to delete his own answer' do
        sign_in author
        expect { delete :destroy, id: answer, question_id: question }.to change(Answer, :count).by(-1)
      end

      it 'tries to delete his own answer and redirected to the question' do
        sign_in author
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to assigns(:question)
      end
    end
  end
end
