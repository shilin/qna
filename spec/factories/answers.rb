FactoryGirl.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body
    question
  end

  factory :invalid_answer, class: Answer do
    body nil
    question
  end
end
