class User < ApplicationRecord
  include Tagger

  before_destroy :destroy_associated_records

  has_many :ownerships, inverse_of: :user, dependent: :destroy
  has_many :bits, through: :ownerships

  store_accessor :preferences, :time_zone

  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  private

    def destroy_associated_records
      self.bits.in_batches.delete_all
    end
end
