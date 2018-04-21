class CreateContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :contributions do |t|
      t.string :title
      t.string :url
      t.text :text
      t.integer :votes, :default => 0
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
    add_index :contributions, [:user_id, :created_at]
  end
end
