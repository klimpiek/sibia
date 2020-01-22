class AddBookmarkingToBits < ActiveRecord::Migration[6.0]
  def change
    add_reference :bits, :bookmarking, polymorphic: true
  end
end
