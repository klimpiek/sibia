class Preceding < ApplicationRecord
  belongs_to :predecessor, class_name: 'Bit', inverse_of: :succeedings
  belongs_to :successor, class_name: 'Bit', inverse_of: :precedings
end
