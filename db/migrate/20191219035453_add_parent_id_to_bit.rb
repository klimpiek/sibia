class AddParentIdToBit < ActiveRecord::Migration[6.0]
  def change
    add_column :bits, :parent_id, :integer
    add_column :bits, :sort_order, :integer
  end
end
