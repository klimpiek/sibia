class CreateAccountTelegrams < ActiveRecord::Migration[6.0]
  def change
    create_table :account_telegrams do |t|
      t.text :telegram_user
      t.references :user, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
