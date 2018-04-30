class RemoveColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :contributions, :total_Comments
  end
end
