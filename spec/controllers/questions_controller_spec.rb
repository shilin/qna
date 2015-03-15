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

end
