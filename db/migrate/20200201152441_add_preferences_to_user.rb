class AddPreferencesToUser < ActiveRecord::Migration[6.0]
  def change
    add_column    :users, :preferences, :jsonb, null: false, default: {time_zone: 'UTC'}
    remove_column :users, :time_zone, :string, default: 'UTC'
  end
end
