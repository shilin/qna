class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:show, :index]
  def index
    @questions = Question.all
  end
  
  def show
    @question = Question.find(params[:id])
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

  def destroy
    @question = Question.find(params[:id])

    #sleep 15 if  current_user.author_of?(@question)
      #if current_user.author_of?(@question) and @question.destroy
      if current_user.author_of?(@question) and @question.destroy
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



end
