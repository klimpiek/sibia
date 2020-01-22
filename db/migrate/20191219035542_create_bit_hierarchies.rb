class CreateBitHierarchies < ActiveRecord::Migration[6.0]
  def change
    create_table :bit_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :bit_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "bit_anc_desc_idx"

    add_index :bit_hierarchies, [:descendant_id],
      name: "bit_desc_idx"
  end
end
