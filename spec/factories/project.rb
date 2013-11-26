 Factory.define :sponsor, :class => Organization do |f|
   f.name "Sponsor"
 end

 Factory.define :coordinator, :class => Organization do |f|
   f.name "Coordinator"
 end

 Factory.define :benefit do |f|
   f.name "Benefit"
 end

 Factory.define :project do |f|
   f.coordinator { Factory.build(:coordinator) }
   f.sponsor { Factory.build(:sponsor) }
   f.benefit { Factory.build(:benefit) }
   f.participation_count 0
   f.incorrect_count 0
   f.skipped_count 0
   f.correct_count 0
   f.rate 100
   f.limit 100
   f.start_time Time.now
   f.end_time Time.now + 1.hour
 end
