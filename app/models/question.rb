class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: Answer

  validates :title, :body, :user, presence: true
end
