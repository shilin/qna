require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index}
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end

  end

  describe 'GET #show' do
    let(:question) {create(:question)}

    before {get :show, id: question}

    it 'assigns question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before {sign_in_user; get :new}

    it 'assigns a new Question to question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders a new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    let(:question) {create(:question)}
    let(:invalid_question) {create(:invalid_question)}

    context 'Unauthenticated user' do
      context 'tries to create a question with valid attributes' do

        it 'fails to save a question into db' do
          expect { post :create, question: attributes_for(:question) }.
            to_not change(Question,:count)
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
          expect { post :create, question: attributes_for(:question) }.
            to change(Question,:count).by(1)
        end
        it 'redirects to show view' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'tries to create a question with invalid attributes' do

        it 'fails to save a question' do
          expect {post :create, question: attributes_for(:invalid_question)}.
            to_not change(Question,:count)
        end
        it 're-renders new view' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template :new
        end


      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) {create(:question)}

    before {question}
    context 'Unauthenticated user' do
      it 'tries to delete a question' do
        expect {delete :destroy, id: question}.to_not change(Question, :count)
      end
      it 'redirects to show path' do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Authenticated user' do
      it 'tries to delete a question' do
        sign_in_user
        expect {delete :destroy, id: question}.to_not change(Question, :count)
      end
    end

    context 'Author' do
      it 'tries to delete his own question' do
        sign_in_user
        question.user=@user
        question.save
        expect {delete :destroy, id: question}.to change(Question, :count).by(-1)
      end

    end

  end

end
