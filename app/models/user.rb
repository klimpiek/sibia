class User < ApplicationRecord
  include Tagger

  has_many :ownerships, inverse_of: :user, dependent: :destroy
  has_many :bits, through: :ownerships

  store_accessor :preferences, :time_zone

  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
