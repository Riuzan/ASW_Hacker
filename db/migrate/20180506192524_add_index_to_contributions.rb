class AddIndexToContributions < ActiveRecord::Migration[5.1]
  def change
    add_index :contributions, :url, unique: true
  end
end
