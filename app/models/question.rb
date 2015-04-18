class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :attachments

  validates :title, :body, :user, presence: true
end
