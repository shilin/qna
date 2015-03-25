class AnswersController < ApplicationController

  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_answer, only: [:show, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)

    if @answer.save
      flash[:notice] = 'Your answer is saved successfully!'
      redirect_to [@question,@answer]
    else
      flash[:alert] = 'Failed to save your answer!'
      render :new
    end

  end

  def show
  end

  def destroy

      if current_user.author_of?(@answer) and @answer.destroy
        flash[:notice] = 'Answer has been removed'
      else
        flash[:alert] = 'Failed to remove the answer'
      end
      redirect_to question_answer_path(@answer.question, @answer)
  end

  private

  def answer_params
    params.require(:answer).permit([:body,:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

end
