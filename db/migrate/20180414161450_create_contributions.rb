class CreateContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :contributions do |t|
      t.string :title
      t.string :url, unique: true
      t.text :text
      t.string :type
      t.integer :votes, :default => 0
      t.references :user, foreign_key: true, index: true
      t.references :parent, index: true
      t.timestamps
    end
    add_index :contributions, [:user_id, :created_at]
  end
end
