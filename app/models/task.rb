class Task < ApplicationRecord
  belongs_to :user
  before_create :assign_random_color

  private

  def assign_random_color
    colors = Array["#E1D2FF", "#FDE1AC", "#BAE5F5", "#CCEFBF"]
    random_number = rand(0..3) 
    self.color = colors[random_number]
  end
end
