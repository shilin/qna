class AnswersController < ApplicationController

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to [@question,@answer]
    else
      render :new
    end

  end


  private

  def answer_params
    params.require(:answer).permit([:body,:question_id])
  end

end
