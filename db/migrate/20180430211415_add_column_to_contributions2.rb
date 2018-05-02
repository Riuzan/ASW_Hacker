class AddColumnToContributions2 < ActiveRecord::Migration[5.1]
  def change
    add_column :contributions, :comment_type, :string
  end
end
