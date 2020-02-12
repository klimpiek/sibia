class CreatePrecedings < ActiveRecord::Migration[6.0]
  def change
    create_table :precedings do |t|
      t.references :predecessor, null: false, foreign_key: { to_table: :bits, on_delete: :cascade }
      t.references :successor, null: false, foreign_key: { to_table: :bits, on_delete: :cascade }

      t.timestamps
    end
  end
end
