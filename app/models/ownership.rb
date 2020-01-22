class Ownership < ApplicationRecord
  include Tagging

  belongs_to :user, inverse_of: :ownerships, touch: true
  belongs_to :bit, inverse_of: :ownerships, touch: true
end
