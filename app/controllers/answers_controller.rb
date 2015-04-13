class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_answer, only: [:show, :update, :destroy]
  before_action :load_question, only: [:update, :create]
  before_action :discard_not_question_authors_calling_answer_best, only: [:update, :create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Your answer is saved successfully!'
    else
      flash[:alert] = 'Failed to save your answer!'
    end
  end

  def show
  end

  def update
    if current_user.try(:author_of?, @answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def destroy
    @question = @answer.question

    if current_user.try(:author_of?, @answer) && @answer.destroy
      flash[:notice] = 'Answer has been removed'
    else
      flash[:alert] = 'Failed to remove the answer'
    end

  end

  private

  def answer_params
    params.require(:answer).permit([:body, :grateful_question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def discard_not_question_authors_calling_answer_best
    answer_params.delete(:best) unless current_user.try(:author_of?, @question)
    @question.best_answer_id = answer_params.delete(:grateful_question_id)
  end
end
