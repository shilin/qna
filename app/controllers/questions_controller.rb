class QuestionsController < ApplicationController

  def index
    @questions = Question.all
  end
  
  def show
    @question = Question.find(params[:id])
    @size = @question.answers.size
    #@answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:notice] = 'Question successfully created'
      redirect_to @question
    else
      flash[:alert] = 'Failed to create question'
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit([:title, :body])
  end



end
