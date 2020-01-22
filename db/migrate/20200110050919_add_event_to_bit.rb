class AddEventToBit < ActiveRecord::Migration[6.0]
  def change
    add_column :bits, :begin_at, :datetime
    add_column :bits, :end_at, :datetime
    add_column :bits, :begin_at_time_zone, :string
    add_column :bits, :end_at_time_zone, :string
    add_column :bits, :all_day, :boolean, default: false
  end
end
