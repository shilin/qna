class AnswersController < ApplicationController

  before_action :authenticate_user!, except: [:show, :index]
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
    @answer = Answer.find(params[:id])
   # @question = Question.find(params[:question_id])
  end


  private

  def answer_params
    params.require(:answer).permit([:body,:question_id])
  end

end
