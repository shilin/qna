class AddColumnBestAnswerToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :best_answer, index: true
    add_foreign_key :questions, :answers, column: :best_answer_id
  end
end
