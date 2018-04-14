class CreateContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :contributions do |t|
      t.string :title
      t.string :url
      t.text :text
      t.integer :votes, :default => 0
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
    add_index :contributions, [:user_id, :created_at]
    add_index :contributions, [:comment_id, :created_at]
  end
end
