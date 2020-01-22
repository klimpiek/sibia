class User < ApplicationRecord
  include Tagger

  has_many :ownerships, inverse_of: :user, dependent: :destroy
  has_many :bits, through: :ownerships

  has_many :lines, class_name: 'Account::Line', dependent: :destroy, inverse_of: :user
  has_many :telegrams, class_name: 'Account::Telegram', dependent: :destroy, inverse_of: :user

  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
