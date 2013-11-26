Factory.define :user do |f|
  f.sequence(:email) { |n| "foo#{n}@example.com" }
  f.password "secret"
  f.name "Foo Bar"
  f.nickname "foo"
  f.correct_count 10
  f.skipped_count 10
  f.incorrect_count 10
  f.contribution 10
end

Factory.define :auth_sina, :class => Authentication do |f|
  f.provider 'tsina'
  f.uid '12345'
end

Factory.define :sina_user, :class => User do |f|
  f.name ""
  f.nickname "foo"
  f.authentication { Factory.build(:auth_sina) }
end

Factory.define :participation do |f|
  f.user { Factory :user }
  f.project { Factory :project}
end
