class Answer < ActiveRecord::Base
  validates :body, :user, presence: true

  belongs_to :question
  belongs_to :user
end
