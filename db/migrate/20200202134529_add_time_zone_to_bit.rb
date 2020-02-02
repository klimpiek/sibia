class AddTimeZoneToBit < ActiveRecord::Migration[6.0]
  def change
    add_column :bits, :time_zone, :jsonb, null: false, default: {}
    remove_column :bits, :due_at_time_zone, :string
    remove_column :bits, :begin_at_time_zone, :string
    remove_column :bits, :end_at_time_zone, :string
  end
end
