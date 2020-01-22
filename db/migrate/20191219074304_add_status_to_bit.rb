class AddStatusToBit < ActiveRecord::Migration[6.0]
  def change
    add_column :bits, :due_at, :datetime
    add_column :bits, :due_at_time_zone, :string
    add_column :bits, :status, :integer, default: 0
  end
end
