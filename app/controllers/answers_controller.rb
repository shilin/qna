class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_answer, only: [:show, :update, :destroy]

  def create
    @question = Question.find(params[:question_id])
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

    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit([:body])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
