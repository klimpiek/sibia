class CreateWorkspaces < ActiveRecord::Migration[6.0]
  def change
    create_table :workspaces do |t|
      t.text :title, null: false
      t.text :description

      t.timestamps
    end
  end
end
