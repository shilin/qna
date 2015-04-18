require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, id: question }

    it 'assigns question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      sign_in_user
      get :new
    end

    it 'assigns a new Question to question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'creates a new linked attachment to question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders a new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:invalid_question) { create(:invalid_question) }

    context 'Unauthenticated user' do
      context 'tries to create a question with valid attributes' do
        it 'fails to save a question into db' do
          expect { post :create, question: attributes_for(:question) }
            .to_not change(Question, :count)
        end

        it 'redirects to index view' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    context 'Authenticated user' do
      before { sign_in_user }

      context 'creates a question with valid attributes' do
        it 'saves a question into db' do
          expect { post :create, question: attributes_for(:question) }
            .to change(Question, :count).by(1)
        end

        it 'makes current user an owner of the saved question' do
          expect { post :create, question: attributes_for(:question) }
            .to change(@user.questions, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'tries to create a question with invalid attributes' do
        it 'fails to save a question' do
          expect { post :create, question: attributes_for(:invalid_question) }
            .to_not change(Question, :count)
        end
        it 're-renders new view' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }

    before { question }
    context 'Unauthenticated user' do
      it 'tries to delete a question' do
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end
      it 'redirects to show path' do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Authenticated user' do
      it 'tries to delete a question' do
        sign_in_user
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end
    end

    context 'Author' do
      it 'tries to delete his own question' do
        sign_in_user
        question.update(user: @user)
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end
    end
  end

  describe 'PATCH #update' do
    let(:author) { create(:user) }
    let!(:question) { create(:question, user: author) }

    context 'Unauthenticated user' do
      it 'does not assigns @question' do
        patch :update, id: question, question: { title: 'New question title', body: 'New question body' }, format: :js
        expect(assigns(:question)).to be_nil
      end
      it 'does not update attributes' do
        patch :update, id: question, question: { title: 'New question title', body: 'New question body' }, format: :js
        expect(question.title).to_not eq 'New question title'
        expect(question.body).to_not eq 'New question body'
      end
      it 'responses you are not authorized' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response.status).to eq 401
      end
    end

    context 'Authenticated user' do
      before { sign_in_user }

      it 'assigns @question' do
        patch :update, id: question, question: { title: 'New question title', body: 'New question body' }, format: :js
        expect(assigns(:question)).to eq question
      end
      it 'does not update attributes' do
        patch :update, id: question, question: { title: 'New question title', body: 'New question body' }, format: :js
        expect(assigns(question.title)).to_not eq 'New question title'
        expect(assigns(question.body)).to_not eq 'New question body'
      end
      it 'tries to update not his question' do
        expect { patch :update, id: question, question: attributes_for(:question), format: :js }
          .to_not change(Question, :count)
      end
      it 'tries to update not his question and update template is rendered' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'Author' do
      before { sign_in author }

      it 'assigns the requested question to @question' do
        patch :update, id: question, question_id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'New question title', body: 'New question body' }, format: :js
        expect(assigns(:question).title).to eq 'New question title'
        expect(assigns(:question).body).to eq 'New question body'
      end

      it 'renders update template' do
        patch :update, id: question, question: { title: 'New question title', body: 'New question body' }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
