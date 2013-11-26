3.upto(100) do |num|
  user = User.create(email: num.to_s+"@sizhong.com",password:"123456",password_confirmation:"123456",nickname:"sizhong"+num.to_s,answer_quota:1000000000)
  
  for q in QuestionSet.all
    user.question_sets << q
  end
  
end