class Answer < ActiveRecord::Base
  has_one :grateful_question, foreign_key: :best_answer_id, class_name: Question
  belongs_to :question
  belongs_to :user

  validates :body, :user, presence: true
end
