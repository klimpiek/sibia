class CreateAccountLines < ActiveRecord::Migration[6.0]
  def change
    create_table :account_lines do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.text :nonce
      t.text :line_user

      t.timestamps
    end
  end
end
