class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_answer, only: [:show, :update, :update_best, :destroy]
  before_action :load_question, only: [:update, :update_best, :create]

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

  def update_best
    @answer.update(best: answer_params[:best]) if current_user.author_of?(@question)
    render :update
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    # @question = @answer.question
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
    params.require(:answer).permit([:body, :best])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
