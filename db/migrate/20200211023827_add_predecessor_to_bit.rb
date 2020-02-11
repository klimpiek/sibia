class AddPredecessorToBit < ActiveRecord::Migration[6.0]
  def change
    add_reference :bits, :predecessor, foreign_key: { to_table: :bits }
  end
end
