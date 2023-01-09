class Counter < ActiveRecord::Base
  def increment!
    self.visits ||= 0
    self.visits += 1
    self.save!
  end
end
