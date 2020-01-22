class CreateBits < ActiveRecord::Migration[6.0]
  def change
    create_table :bits do |t|
      t.text :title, null: false
      t.text :description
      t.text :content
      t.text :uri

      t.timestamps
    end
  end
end
