class Bit < ApplicationRecord
  include Taggable

  validates :title, presence: true, unless: :uri?

  has_closure_tree name_column: :title, order: 'sort_order', numeric_order: true

  has_many :ownerships, inverse_of: :bit, dependent: :destroy
  has_many :users, through: :ownerships

  belongs_to :bookmarking, polymorphic: true, optional: true

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