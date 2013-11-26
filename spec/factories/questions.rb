Factory.define :category do |f|
  f.sequence(:name) {|n| "QuestionSet#{n}"}
end

Factory.define :question_set do |f|
  f.sequence(:name) {|n| "QuestionSet#{n}"}
end

Factory.define :question do |f|
  f.sequence(:title) {|n| "question #{n}"}
  f.c1 "choice 1"
  f.c2 "choice 2"
  f.c3 "choice 3"
  f.c4 "choice 4"
  f.correct_index rand(4)
  f.category {Factory :category}
  f.token "t" * 40
end

Factory.define :sponsor_question, :class => Question do |f|
  f.sequence(:title) {|n| "sponsor question #{n}"}
  f.c1 "sponsor choice 1"
  f.c2 "sponsor choice 2"
  f.c3 "sponsor choice 3"
  f.c4 "sponsor choice 4"
  f.correct_index rand(4)
  f.category_id 1
  f.sponsor_id 1
  f.token "s" * 40
end

Factory.define :survey do |f|
  f.sequence(:title) {|n| "survey #{n}"}
  f.choice1 "survey choice 1"
  f.choice2 "survey choice 2"
  f.choice3 "survey choice 3"
  f.choice4 "survey choice 4"
  f.count1 0
  f.count2 0
  f.count3 0
  f.count4 0
end

Factory.define :correct_sponsor_answer, :class => Answer do |f|
  f.question { Factory :sponsor_question }
  f.user {Factory :user}
  f.state 1
end

Factory.define :correct_answer, :class => Answer do |f|
  f.question { Factory :question }
  f.user {Factory :user}
  f.state 1
end

Factory.define :incorrect_answer, :class => Answer do |f|
  f.question { Factory :question }
  f.user {Factory :user}
  f.state 0
end

Factory.define :skipped_answer, :class => Answer do |f|
  f.question { Factory :question }
  f.user {Factory :user}
  f.state 2
end
