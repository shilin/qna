require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index}
    it 'populates an array of all questions' do
      expect(assigns(:questions)).to eq questions
    end

    it 'renders view index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before {get :new}
    it 'assigns a new Question to question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders a new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    let(:invalid_question) {create(:invalid_question)}

    context 'with valid attributes' do

      it 'saves a question into db' do
        expect { post :create, question: {title: 'Title', body: 'Body'} }.to change(Question,:count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: {title: 'Title', body: 'Body'}
        expect(response).to redirect_to question_path(assigns(:question))
      end

    end

    context 'with invalid attributes' do

      it 'fails to save a question' do
        expect {post :create, question: attributes_for(:invalid_question)}.to_not change(Question,:count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end

    end


  end


end
