class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :update, :destroy]
  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      flash[:notice] = 'Question successfully created'
      redirect_to @question
    else
      flash[:alert] = 'Failed to create question'
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.try(:author_of?, @question)
  end

  def destroy
    if current_user.author_of?(@question) && @question.destroy
      flash[:notice] = 'Question has been removed'
    else
      flash[:alert] = 'Failed to remove the question'
    end
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit([:title, :body])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
