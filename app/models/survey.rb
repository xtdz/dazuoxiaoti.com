class Survey < ActiveRecord::Base
  validates_presence_of :title, :choice1, :choice2

  def choices
    [choice1, choice2, choice3, choice4]
  end

  def counts
    [count1, count2, count3, count4]
  end

# the input of this method is a string!! not an integer
  def increase_count(index)
    case parse_index(index)
      when 0
        self.count1 = self.count1 + 1
      when 1
        self.count2 = self.count2 + 1
      when 2
        self.count3 = self.count3 + 1
      when 3
        self.count4 = self.count4 + 1
    end
    save
  end

  def parse_index(index)
    if index == "0"
      0
    elsif index.to_i != 0
      index.to_i
    else
      -1
    end
  end
end
