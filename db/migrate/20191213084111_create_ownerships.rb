class CreateOwnerships < ActiveRecord::Migration[6.0]
  def change
    create_table :ownerships do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :bit, null: false, foreign_key: { on_delete: :cascade }
      t.text :tags, array: true
      t.boolean :favorite, default: false

      t.timestamps

    end

    add_index :ownerships, :tags, using: :gin
  end
end
