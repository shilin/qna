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
          expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }
            .to_not change(Answer, :count)
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
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to_not change(Answer, :count)
      end
      it 'responses with non-authorized status' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response.status).to eq 401
      end
    end

    context 'Authenticated user' do
      it 'tries to delete an answer' do
        sign_in_user
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to_not change(Answer, :count)
      end
      it 'tries to delete an answer and redirected' do
      end
    end

    context 'Author' do
      it 'tries to delete his own answer and answer deleted' do
        sign_in author
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'tries to delete his own answer and status is success' do
        sign_in author
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response.status).to eq 200
      end
    end
  end

  describe 'PATCH #update' do
    let(:author) { create(:user) }
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: author) }

    context 'Unauthenticated user' do
      it 'tries to edit an answer' do
        expect { patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          .to_not change(Answer, :count)
      end
      it 'responses you are not authorized' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response.status).to eq 401
      end
    end

    context 'Authenticated user' do
      before { sign_in_user }

      it 'tries to update not his answer' do
        patch :update, id: answer, question_id: question, answer: { body: 'New answer body' }, format: :js
        expect(assigns(:answer).body).to_not eq 'New answer body'
      end
      it 'tries to update not his answer and update template is rendered' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'Author' do
      before { sign_in author }

      it 'assigns @question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer: { body: 'New answer body' }, format: :js
        expect(assigns(:answer).body).to eq 'New answer body'
      end

      it 'renders update template' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #update_best' do
    let(:question_author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: question_author) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Unauthenticated user' do
      it 'tries to make an answer to be best' do
        expect { patch :update_best, id: answer, question_id: question, answer: { best: true }, format: :js }
          .to_not change(answer, :best)
      end
      it 'responses you are not authorized' do
        patch :update_best, id: answer, question_id: question, answer: { best: true }, format: :js
        expect(response.status).to eq 401
      end
    end

    context 'Authenticated user' do
      before { sign_in user }

      it 'tries to make an answer best' do
        expect { patch :update_best, id: answer, question_id: question, answer: { best: true }, format: :js }
          .to_not change(answer, :best)
      end
      it 'tries to make an answer to be best and update template renders' do
        patch :update_best, id: answer, question_id: question, answer: { best: true }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Author of a related question' do
      before { sign_in question_author }

      it 'assigns @question' do
        patch :update_best, id: answer, question_id: question, answer: { best: true }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'assigns the requested answer to @answer' do
        patch :update_best, id: answer, question_id: question, answer: { best: true }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'makes an answer to be the best' do
        patch :update_best, id: answer, question_id: question, answer: { best: true }, format: :js
        expect(assigns(:answer).best).to eq true
      end

      it 'renders update template' do
        patch :update_best, id: answer, question_id: question, answer: { best: true }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
