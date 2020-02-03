class CreateConstituents < ActiveRecord::Migration[6.0]
  def change
    create_table :constituents do |t|
      t.references :workspace, null: false, foreign_key: { on_delete: :cascade }
      t.references :bit, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
