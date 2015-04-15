class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :user, presence: true

  before_save :ensure_no_best_answers_left, if: ->() { best_changed? }

  scope :best_first, -> { order(best: :desc, created_at: :asc) }

  protected

  def ensure_no_best_answers_left
    Answer.where(question_id: question_id, best: true).update_all(best: false)
  end
end
