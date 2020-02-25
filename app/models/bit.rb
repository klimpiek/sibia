class Bit < ApplicationRecord
  include Taggable

  store_accessor :time_zone, :due_at, :begin_at, :end_at, suffix: true

  validates :title, presence: true, unless: :uri?

  has_closure_tree name_column: :title, order: 'sort_order', numeric_order: true

  has_many :ownerships, inverse_of: :bit, dependent: :destroy
  has_many :users, through: :ownerships

  belongs_to :bookmarking, polymorphic: true, optional: true

  # For one predecessor per bit
  belongs_to :predecessor, class_name: 'Bit', optional: true, inverse_of: :successors
  has_many :successors, class_name: 'Bit', foreign_key: 'predecessor_id', dependent: :nullify, inverse_of: :predecessor

  # For many-to-many depencendies
  has_many :precedings, class_name: 'Preceding', foreign_key: :successor_id, 
                        inverse_of: :successor, dependent: :destroy
  has_many :succeedings, class_name: 'Preceding', foreign_key: :predecessor_id,
                         inverse_of: :predecessor, dependent: :destroy

  enum status: { unassigned: 0, todo: 1, ongoing: 8, waiting: 32, completed: 64 }

  scope :favorites, -> { where('ownerships.favorite': true) }
  scope :links, -> { where.not(uri: '') }
  scope :tasks, -> { where.not(status: :unassigned) }
  scope :events, -> { where.not(begin_at: nil) }

  scope :due_in, ->(range) { where(due_at: range) }
  scope :occur_in, ->(range) { where.not('end_at < ? OR begin_at > ?', range.begin, range.end) }

  scope :recent_first, -> { reorder('bits.updated_at DESC') }

  def favorite?(user:)
    self.ownerships.find_by(user: user).favorite
  end

  # Fill fields with meta. It will overwrite original fields
  def get_meta
    if self.uri.present?
      begin
        page = MetaInspector.new(self.uri)
      rescue
      end

      if page && page.title.present?
        self.title = page.title
        self.description = page.description
        self.uri = page.url
      else
        self.title = bit.uri
      end
    end
  end
end
